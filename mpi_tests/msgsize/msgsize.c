/****************************************************************************
* FILE: msgsize.c
* DESCRIPTION:
*   This code conducts timing tests on messages sent between two processes.
*   It sends/receives N roundtrips of incrementally sized messages
*   from start size J to finish size K by increment I.  T trials are run
*   and the best result used.  
* LAST REVISED: 12/27/98 Blaise Barney
******************************************************************************/

#include "mpi.h"
#include <stdio.h>

/* Modify these to change timing scenario */
#define TRIALS          10
#define START           100000
#define FINISH          1000000
#define REPS            100
#define INCR            50000
#define MAXPOINTS       10000

int    numtasks, rank, n, i, j, k, this, msgsizes[MAXPOINTS];
float  bandwidth, tbytes, results[MAXPOINTS];
double t1, t2, ttime;
char   c[FINISH], host0[MPI_MAX_PROCESSOR_NAME], 
       host1[MPI_MAX_PROCESSOR_NAME];
MPI_Status Stat;

int main(argc,argv)
int argc;
char *argv[];  {

/* Minor error check */
if ( ((FINISH - START)/INCR) > MAXPOINTS) {
  printf("\nMaximum number of datapoints exceeded.  Terminating.\n");
  exit(0);
  }

MPI_Init(&argc,&argv);
MPI_Comm_size(MPI_COMM_WORLD, &numtasks);
MPI_Comm_rank(MPI_COMM_WORLD, &rank);

/**************************** task 0 ***********************************/
if (rank == 0) {

  /* Initialize arrays which hold timing stats  - and other things too */
  this=0;
  for (n=START; n<=FINISH; n=n+INCR) {
    msgsizes[this] = n;
    results[this] = 0.0; 
    this++;
    }
  MPI_Get_processor_name(host0, &n);
  MPI_Recv(&host1, 35, MPI_CHAR, 1, 999, MPI_COMM_WORLD, &Stat);
  for (i=0; i<FINISH; i++)
    c[i] = 'x';

  /* Greetings */
  printf("\n******** MPI BANDWIDTH TEST ********\n");
  printf("Start size=  %8d bytes\n",START);
  printf("Finish size= %8d bytes\n",FINISH);
  printf("Increment=   %8d bytes\n",INCR);
  printf("Trials=      %8d\n",TRIALS);
  printf("Reps/trial=  %8d\n",REPS);
  printf("Hosts= %s %s\n",host0,host1);
  printf("\n************* RESULTS **************\n");
  printf("Message Size   Bandwidth (bytes/sec)\n");

  /* Begin timings */
  for (k=0; k<TRIALS; k++) {
    this = 0;
    for (n=START; n<=FINISH; n=n+INCR) {

      t1 = MPI_Wtime();
      for (i=1; i<=REPS; i++){
        MPI_Send(&c, n, MPI_CHAR, 1, 998, MPI_COMM_WORLD);
        MPI_Recv(&c, n, MPI_CHAR, 1, 999, MPI_COMM_WORLD, &Stat);
        }
      t2 = MPI_Wtime();

      /* Compute bandwidth and use best result */
      ttime = t2 - t1;
      tbytes = sizeof(char) * n * 2.0 * (float)REPS;
      bandwidth = tbytes/ttime;
      if (results[this] < bandwidth)
         results[this] = bandwidth;

      this++; 
      }   /* end n loop */
    }     /* end k loop */

  /* Print results */
  this=0;
  for (n=START; n<=FINISH; n=n+INCR) {
    printf("%9d %16d\n", msgsizes[this], (int)results[this]);
    this++;
    }

  }       /* end of task 0 */



/****************************  task 1 ************************************/
if (rank == 1) {

  /* Initializations */
  MPI_Get_processor_name(host1, &n);
  MPI_Send(&host1, 35, MPI_CHAR, 0, 999, MPI_COMM_WORLD);

  /* Begin timing tests */
  for (k=0; k<TRIALS; k++) {
    for (n=START; n<=FINISH; n=n+INCR) {
      for (i=1; i<=REPS; i++){
        MPI_Recv(&c, n, MPI_CHAR, 0, 998, MPI_COMM_WORLD, &Stat);
        MPI_Send(&c, n, MPI_CHAR, 0, 999, MPI_COMM_WORLD);
        }
      }   /* end n loop */
    }     /* end k loop */
  }       /* end task 1 */


MPI_Finalize();

}  /* end of main */

