function F = root2d(x,t ,d , p )
z = (1.1574*t^3-2.3148*t^4+1.1574*t^5) ;
x_ = -(-0.03*0+0.48*t^2-0.12*t^3) ;


F(1) = sin(x(4))+sin(x(5)+x(4)) - sin(x(1))-sin(x(1)+x(2))-z; %z(t) ;

F(2) = x_+cos(x(1)+x(2))+cos(x(1))-cos(x(5)+x(4))-cos(x(4)) ;
            %x
F(3) = cos(x(4)) + cos(x(5)+x(4))-p*x_; %x(t) ;
F(4) = x(1)+x(2)+x(3)-pi ;
F(5) = x(4)+x(5)+x(6)-pi ;


%F(6) = x_ +cos(x(1)+x(2)) + cos(x(1)) - cos(x(4))-cos(x(4)+x(5)) ;
end     %x