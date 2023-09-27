clear
clc
%close all
s = serial('COM4');
set(s,'BaudRate',115200);
fopen(s)
try
    mm = load('masir_new.mat');
    fwrite(s ,'O'); 
    'bbb'
        
    sta = input('start = ');
    %mm.tt(:,1) = zeros(8,1);
    %mm.q(1) = 0;
    
    i = 0;
    y = [];
    setPoints = [];
    %mm.p = -mm.p;
    %mm.q = -mm.q;
        
    xxset=[];
    yyset=[];
    xx = [];
    yy = [];
    z1 = [];
    z2 = [];
    z1_ = [];
    z2_ = [];

    [p_qSize1 p_qSize]= size(mm.tt)
    
    if(sta == 1) 
    for jj =1:p_qSize+50
        
        if(jj<=50)
            setPoint = [mm.tt(1:4,1);-mm.tt(5:8,1) ]*768/(2*3.14);%+ [20;20;20;20;-20;-20;-20;-20]*0.5 ;%[mm.q(jj) , mm.p(jj)];
        
        else    
            setPoint = [mm.tt(1:4,jj-50);-mm.tt(5:8,jj-50) ]*768/(2*3.14);%+[20;20;20;20;-20;-20;-20;-20]*0.5;%[mm.q(jj) , mm.p(jj)];
        end
        'aaa'
        setPoints(jj,:) = setPoint ;

        tp = zeros(2,8);
        tp(1,:) = mod(setPoint + 768 , 64);
        tp(2,:) = floor((setPoint + 768) / 64);
% 
%         tp(2,1) = floor((setPoint(1) + 768) / 64);
% 
%         tp(1,2) = mod(setPoint(2) + 768 , 64);
%         tp(2,2) = floor((setPoint(2) + 768) / 64);
% 
%         tp(1,3) = mod(setPoint(3) + 768 , 64);
%         tp(2,3) = floor((setPoint(3) + 768) / 64);
% 
%         tp(1,4) = mod(setPoint(4) + 768 , 64);
%         tp(2,4) = floor((setPoint(4) + 768) / 64);
% 
%         tp(1,5) = mod(setPoint(5) + 768 , 64);
%         tp(2,5) = floor((setPoint(5) + 768) / 64);
% 
%         tp(1,6) = mod(setPoint(6) + 768 , 64);
%         tp(2,6) = floor((setPoint(6) + 768) / 64);
%         
%         tp(1,7) = mod(setPoint(7) + 768 , 64);
%         tp(2,7) = floor((setPoint(7) + 768) / 64);
%         
%         tp(1,8) = mod(setPoint(8) + 768 , 64);
%         tp(2,8) = floor((setPoint(8) + 768) / 64);
        %tp
        tic
        fwrite(s ,'S'); 
        fwrite(s , char(tp(1,1)));
        fwrite(s , char(tp(2,1)));
        fwrite(s , char(tp(1,2)));
        fwrite(s , char(tp(2,2)));
        fwrite(s , char(tp(1,3)));
        fwrite(s , char(tp(2,3)));
        fwrite(s , char(tp(1,4)));
        fwrite(s , char(tp(2,4)));
        fwrite(s , char(tp(1,5)));
        fwrite(s , char(tp(2,5)));
        fwrite(s , char(tp(1,6)));
        fwrite(s , char(tp(2,6)));
        fwrite(s , char(tp(1,7)));
        fwrite(s , char(tp(2,7)));
        fwrite(s , char(tp(1,8)));
        fwrite(s , char(tp(2,8)));
       
        fwrite(s , 'E');
        sending_time(jj) = toc;
        
        tic
        tt = 0;
        
        val = setPoint;
        v = [];
        timeCome = [];
        readVal = 0;
        e = [];
        myt = [];
        Anum = 0;
        %% inisial for controling 
        Serror = 0; error = 0; Ki = 0.1; Kp = 0.3; 
        miliSecendTimeSampling = 100;

        %% loop

        startRead = 1;
        w_i = 0;
        while(tt< 0.3)
            tt = toc;
            sizeAvailable = s.BytesAvailable;
            if(sizeAvailable >= 18)
                
                readVal(startRead:startRead+sizeAvailable-1) = fread(s ,sizeAvailable, 'int8');
                w_i=w_i+1;
                
                i=i+1;
                [y(i,:) , readVal] = decodeEncoders(readVal);
                [startRead, chert] = size(readVal);
                %startRead
                timeCome(i) = tt;
                SS= setPoint'
                YY = y(i,:)
                myt(i) = tt;
                
                
                z1(i) = y(i,2)*2*pi/(12*64);
                z2(i) = y(i,1)*2*pi/(12*64);
                
                tolA = 12;
                tolB = 8.7;
    
    
                %yy(i) = -cos(z1(i))*tolA - cos(z2(i)+z1(i))*tolB;
                %xx(i) = sin(z1(i))*tolA + sin(z2(i)+z1(i))*tolB;
                %hold on
                
                %plot(xx,yy, 'b');
                
                %z1_(i) = setPoint(2)*2*pi/(12*64);
                %z2_(i) = setPoint(1)*2*pi/(12*64);


                %yyset(i) = -cos(z1_(i))*tolA - cos(z2_(i)+z1_(i))*tolB;
                %xxset(i) = sin(z1_(i))*tolA + sin(z2_(i)+z1_(i))*tolB;
                
                %plot(xxset,yyset , 'r');
                %drawnow;
                
            end
        end
        
        WW(jj) = w_i;
    end
    end
    %plot(timeCome , y(:,1),'r');
    %hold on
    %plot(timeCome , v(:,1),'b');
    
    %figure;
    %plot(timeCome , y(:,2),'r');
    %hold on
    %plot(timeCome , v(:,2),'b');
    
    %y
    %v

    fclose(s)
    delete(s)
    clear s
    
    %z1error = sum(abs(z1 - z1_))/i
    %z2error = sum(abs(z2 - z2_))/i
    %placeError = sum(sqrt((xxset - xx).^2 +(yyset-yy).^2))/i
    
%     z1 = y(:,2)*2*pi/(12*64);
%     z2 = y(:,1)*2*pi/(12*64);
%     
%     tolA = 12;
%     tolB = 8.7;
%     xx = [];
%     yy = [];
%     [s1 s2] = size(y);
%     
%     
%      for j=1:s1
%         yy(j) = -cos(z1(j))*tolA - cos(z2(j)+z1(j))*tolB;
%         xx(j) = sin(z1(j))*tolA + sin(z2(j)+z1(j))*tolB;
%      end
%     
%     plot(xx,yy)
%     z1 = mm.p*2*pi/(12*64);
%     z2 = mm.q*2*pi/(12*64);
%     
%     xxset=[];
%     yyset=[];
%     for j=1:25
%         yyset(j) = -cos(z1(j))*tolA - cos(z2(j)+z1(j))*tolB;
%         xxset(j) = sin(z1(j))*tolA + sin(z2(j)+z1(j))*tolB;
%     end
%     hold on
%     plot(xxset,yyset , 'r')
%

catch err

fclose(s)
delete(s)
clear s

end