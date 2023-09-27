clc
clear all
warning off
t_to = .3+0.01;   %meghdar zaman ke yek pa harekat kone
L1 = 1 ; L2 = 1 ; %toole pa
d = 1.5 ;%  arze robot
t = 0:0.01:t_to ;
len_t= length(t) ;
angles = zeros(3,1,2, len_t) ;   % tamam zavaya dar tool harker pa
% 0      zaviye 1
% 0      zaviye 2  
% 0      zaviye 3
% (: , : , paye avala ya dovom , zaman) 


angles(:,:,1,1) = [pi/4 , 2*pi/4 , pi/4] ;
angles(:,:,2,1) = [pi/4 , 2*pi/4 , pi/4] ; 

position = zeros(3,2, 2 , len_t);  % tamam position ha dar tool harker pa
                                   %2D             for 3D zeros(3, 3 , 2)
% x  y  z
% 0  0  0    noke pa  (1)
% 0  0  0    zanoo pa (2)
% 0  0  0    lagan pa (3)
% (: , : , paye avala ya dovom , zaman) 

position(1 , :, 1 , 1) = [-1 , -1] ;

teta0=  [pi/4 , 2*pi/4 , pi/4 ,pi/4 , 2*pi/4 , pi/4 ] ;
t = 0:0.01:t_to ;
X2 = zeros(len_t , 6) ;
X2(1,:) = teta0 ;
for k=2:len_t/2
    fun = @(x)root2d(x,t(k) , 1.5 ,.5) ;
    teta0 = teta0 + [0  , t(k) ,0 ,0 ,0 ,0] ;
    X2(k,:) = fsolve(fun ,teta0 ) ;
    teta0 = X2(k,:) ;
end
for k = (len_t/2+1):len_t
    fun = @(x)root2d(x,t(k) , 1.5 ,.5) ;
    teta0 = teta0 - [0  , t(k) ,0 ,0 ,0 ,0] ;
    X2(k,:) = fsolve(fun ,teta0 ) ;
    teta0 = X2(k,:) ;
end
for k=2:len_t
    angles(:,:,1,k) = [X2(k,1) , X2(k,2) , X2(k,3)] ;
    angles(:,:,2,k) = [X2(k,4) , X2(k,5) , X2(k,6)] ;
end
t = 0:0.01:t_to ;

for k=1:len_t
teta1 = angles(1 , 1 ,1 , k)  ; 
teta2 = angles(2 , 1 ,1 , k)  ;
teta3 = angles(3 , 1 ,1 , k)  ;

x1 = 0 ;
z1 = 0  ; 

% position(1 , :, 1 , k+1) = [x1 , z1] ;

position(2 , :, 1 , k) = [x1 + cos(teta1)*L1 ,z1 + sin(teta1)*L1 ] ;
x2 = position(2,1,1 , k) ;
z2 = position(2,2,1 , k) ; 
position(3 , :, 1 , k) = [x2 + L2*cos(teta1 + teta2) , z2 + L2*sin(teta1 + teta2) ] ;
%hal paye dovom
teta4 = angles(1 , 1 ,2 , k)  ;
teta5 = angles(2 , 1 ,2 , k)  ; 
teta6 = angles(3 , 1 ,2 , k)  ;
x3 = position(3,1,1 , k) ;
z3 = position(3,2,1, k) ;
position(3 , :, 2 , k) = [x3 - d , z3 ];
x4 = position(3,1,2 , k) ;
z4 = position(3,2,2 , k) ;
position(2 , :, 2 , k) = [x4 - L2*cos(teta4+teta5) , z4 - L2*sin(teta4+teta5)];
x5 = position(2,1,2 , k) ;
z5 = position(2,2,2 , k) ;
position(1 , :, 2 , k) = [x5 - L1*cos(teta4) , z5 - L1*sin(teta4)] ;         %
x6 = position(1,1,2 , k) ;
z6 = position(1,2,2 ,k ) ;

line([x1,x2,x3,x4],[z1,z2,z3,z4],'LineWidth',3) ;

hold on
line([x4,x5,x6] ,[z4,z5,z6] ,'LineWidth',3) ;

axis([-3 1 0 4])
pause(.1)
hold on
clf

end

line([x1,x2,x3,x4],[z1,z2,z3,z4],'LineWidth',3) ;
hold on
line([x4,x5,x6] ,[z4,z5,z6] ,'LineWidth',3) ;
axis([-3 1 0 4])

