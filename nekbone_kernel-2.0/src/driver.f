c-----------------------------------------------------------------------
      program kernel

c     Solve Au=w where A is SPD and is invoked by ax()
c
c      u - vector of length n
c      g - geometric factors for SEM operator 
c
c      Work arrays:  wk  
 
      include 'SIZE'
      include 'INPUT'

      parameter (lt=lx1*ly1*lz1*lelt)
      real w(lt),u(lt),gxyz(6*lt)          
      real ur(lt),us(lt),ut(lt),wk(lt)


      call semhat(ah,wxm1,ch,dmx1,zgm1,bh,lx1-1) ! find GLL weights and pts
      call transpose(dxtm1,lx1,dxm1,lx1)         ! transpose D matrix
      call setup_g(gxyz)                         ! geometric factors

      n = lx1*ly1*lz1*lelt    
      call setup_u(u,n)                          ! fill u-vector

      call cpu_time(t0)
      call ax(w,u,gxyz,ur,us,ut,wk,n)            !return w=A*u
      call cpu_time(t1)
      time1 = t1-t0
      
      write(6,1) "Initialization time: ",t0
      write(6,1) "Time in ax(): ",  time1
  1   format(a30,1e14.5) 
      stop
      end
c-----------------------------------------------------------------------
      subroutine transpose(a,lda,b,ldb)
c     Returns the transpone of vector b
      real a(lda,1),b(ldb,1)
 
      do j=1,ldb
         do i=1,lda
            a(i,j) = b(j,i)
         enddo
      enddo
      return
      end
c-----------------------------------------------------------------------
      subroutine setup_g(g)
c     fill g with the GLL weights calculated in semhat routine

      include 'SIZE'
      include 'INPUT'
      real g(6,lx1,ly1,lz1,lelt)
      integer e

      n = lx1*ly1*lz1*lelt


      do e=1,lelt
      do k=1,lz1
      do j=1,ly1
      do i=1,lx1
         call rzero(g(1,i,j,k,e),6)
         g(1,i,j,k,e) = wxm1(i)*wxm1(j)*wxm1(k)
         g(4,i,j,k,e) = wxm1(i)*wxm1(j)*wxm1(k)
         g(6,i,j,k,e) = wxm1(i)*wxm1(j)*wxm1(k)
         g(6,i,j,k,e) = wxm1(i)*wxm1(j)*wxm1(k)
      enddo
      enddo
      enddo
      enddo

      return
      end
c-------------------------------------------------------------------------
      subroutine setup_u(u,n)
c     fill vector u  - "random"
      real u(n)

      do i=1,n
         arg  = 1.e9*(i*i)
         arg  = 1.e9*cos(arg)
         u(i) = sin(arg)
      enddo

      return
      end
c-----------------------------------------------------------------------
      subroutine ax(w,u,gxyz,ur,us,ut,wk,n) ! Matrix-vector product: w=A*u

      include 'SIZE'
      include 'INPUT'

      parameter (lxyz=lx1*ly1*lz1)
      real w(lxyz,lelt),u(lxyz,lelt),gxyz(6,lxyz,lelt)
      parameter (lt=lx1*ly1*lz1*lelt)
      real ur(lt),us(lt),ut(lt),wk(lt)

      integer e

      do e=1,lelt                                ! ~
         call ax_e( w(1,e),u(1,e),gxyz(1,1,e)    ! w   = A  u
     $                             ,ur,us,ut,wk) !  L     L  L
      enddo                                      ! 


      return
      end
c-------------------------------------------------------------------------
      subroutine ax1(w,u,n)
      include 'SIZE'
      real w(n),u(n)
      real h2i
  
      h2i = (n+1)*(n+1)  
      do i = 2,n-1
         w(i)=h2i*(2*u(i)-u(i-1)-u(i+1))
      enddo
      w(1)  = h2i*(2*u(1)-u(2  ))
      w(n)  = h2i*(2*u(n)-u(n-1))

      return
      end
c-------------------------------------------------------------------------
      subroutine ax_e(w,u,g,ur,us,ut,wk) ! Local matrix-vector product
      include 'SIZE'
      include 'INPUT'

      parameter (lxyz=lx1*ly1*lz1)
      real w(lxyz),u(lxyz),g(6,lxyz)

      real ur(lxyz),us(lxyz),ut(lxyz),wk(lxyz)

      nxyz = lx1*ly1*lz1
      n    = lx1-1

      call local_grad3(ur,us,ut,u,n,dxm1,dxtm1)

      do i=1,nxyz
         wr = g(1,i)*ur(i) + g(2,i)*us(i) + g(3,i)*ut(i)
         ws = g(2,i)*ur(i) + g(4,i)*us(i) + g(5,i)*ut(i)
         wt = g(3,i)*ur(i) + g(5,i)*us(i) + g(6,i)*ut(i)
         ur(i) = wr
         us(i) = ws
         ut(i) = wt
      enddo

      call local_grad3_t(w,ur,us,ut,n,dxm1,dxtm1,wk)

      return
      end
c-------------------------------------------------------------------------
      subroutine local_grad3(ur,us,ut,u,n,D,Dt)
c     Output: ur,us,ut         Input:u,n,D,Dt
      real ur(0:n,0:n,0:n),us(0:n,0:n,0:n),ut(0:n,0:n,0:n)
      real u (0:n,0:n,0:n)
      real D (0:n,0:n),Dt(0:n,0:n)
      integer e

      m1 = n+1
      m2 = m1*m1

      call mxm(D ,m1,u,m1,ur,m2)
      do k=0,n
         call mxm(u(0,0,k),m1,Dt,m1,us(0,0,k),m1)
      enddo
      call mxm(u,m2,Dt,m1,ut,m1)

      return
      end
c-----------------------------------------------------------------------
      subroutine local_grad3_t(u,ur,us,ut,N,D,Dt,w)
c     Output: ur,us,ut         Input:u,N,D,Dt
      real u (0:N,0:N,0:N)
      real ur(0:N,0:N,0:N),us(0:N,0:N,0:N),ut(0:N,0:N,0:N)
      real D (0:N,0:N),Dt(0:N,0:N)
      real w (0:N,0:N,0:N)
      integer e

      m1 = N+1
      m2 = m1*m1
      m3 = m1*m1*m1

      call mxm(Dt,m1,ur,m1,u,m2)

      do k=0,N
         call mxm(us(0,0,k),m1,D ,m1,w(0,0,k),m1)
      enddo
      call add2(u,w,m3)

      call mxm(ut,m2,D ,m1,w,m1)
      call add2(u,w,m3)

      return
      end
c-----------------------------------------------------------------------
      subroutine exitt0
      include 'SIZE'
      include 'INPUT'

      write(6,*) 'Exitting....'

      call exit(0)

      return
      end
c-----------------------------------------------------------------------
