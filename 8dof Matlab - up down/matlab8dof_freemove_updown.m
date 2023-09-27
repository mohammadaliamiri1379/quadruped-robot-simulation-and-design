clear
clc
close all
'Hi'

a = 12;
b = 8.7;

MysetPoints = [];

try
    s = serial('COM4');
    'a'
    
    set(s,'BaudRate',115200);
    'b'
    fopen(s)
    'c'
    %teta = [    0.4695 ; -0.6739; 0.5117; -0.5984; 0.4695; -0.6739; 0.5117; -0.5984];
    %setPoint
    fwrite(s ,'O'); 
    setPoint1 = input('setPoint1 = ');
    setPoint2 = input('setPoint2 = ');
    setPoint3 = input('setPoint3 = ');
    setPoint4 = input('setPoint4 = ');
    setPoint5 = input('setPoint5 = ');
    setPoint6 = input('setPoint6 = ');
    setPoint7 = input('setPoint7 = ');
    setPoint8 = input('setPoint8 = ');
   
    i = 0;
    y = [];
    timeCome = [];
    tic;    
    for jj =1:25
         
        if(jj==1)
            state = 1;
            setPoint = [-85, 65,-85, 65, 85, -65, 85,-65];
        elseif(jj ==2)
            state = 1;
            setPoint = [-83, 63, -83, 63, 83, -63, 83,-63];
        
        elseif(jj ==3)
            state = 1;
            setPoint = [-79, 57, -79, 57, 79, -57, 79,-57];
        elseif(jj ==4)
            state = 1;
            setPoint = [-77, 55,-77, 55, 77, -55, 77,-55];
        elseif(jj ==5)
            state = 1;
            setPoint = [-75, 50, -75, 50, 75, -50, 75,-50];
        elseif(jj ==6)
            state = 1;
            setPoint = [-70, 40, -70, 40, 70, -40, 70,-40];
        elseif(jj ==7)
            state = 1;
            setPoint = [-65, 30, -65, 30, 65, -30, 65,-30];
        elseif(jj ==8)
            state = 1;
            setPoint = [-70, 40, -70, 40, 70, -40, 70,-40];
        elseif(jj ==9)
            state = 1;
            setPoint = [-75, 50, -75, 50, 75, -50, 75,-50];
        elseif(jj ==10)
            state = 1;
            setPoint = [-77, 55,-77, 55, 77, -55, 77,-55];
        elseif(jj ==11)
            state = 1;
            setPoint = [-79, 57, -79, 57, 79, -57, 79,-57];
        elseif(jj ==12)
            state = 1;
            setPoint = [-83, 63, -83, 63, 83, -63, 83,-63];
        elseif(jj ==13)
            state = 1;
            setPoint = [-85, 65,-85, 65, 85, -65, 85,-65];
        elseif(jj ==14)
            state = 1;
            setPoint = [-83, 63, -83, 63, 83, -63, 83,-63];
        elseif(jj ==15)
            state = 1;
            setPoint = [-79, 57, -79, 57, 79, -57, 79,-57];
        
        
        elseif(jj ==16)
            state = 1;
            setPoint = [-77, 55,-77, 55, 77, -55, 77,-55];
        elseif(jj ==17)
            state = 1;
            setPoint = [-75, 50, -75, 50, 75, -50, 75,-50];
        elseif(jj ==18)
            state = 1;
            setPoint = [-70, 40, -70, 40, 70, -40, 70,-40];
        elseif(jj ==19)
            state = 1;
            setPoint = [-65, 30, -65, 30, 65, -30, 65,-30];
        elseif(jj ==20)
            state = 1;
            setPoint = [-70, 40, -70, 40, 70, -40, 70,-40];
        elseif(jj ==21)
            state = 1;
            setPoint = [-75, 50, -75, 50, 75, -50, 75,-50];
        
        elseif(jj ==22)
            state = 1;
            setPoint = [-77, 55,-77, 55, 77, -55, 77,-55];
        elseif(jj ==23)
            state = 1;
            setPoint = [-79, 57, -79, 57, 79, -57, 79,-57];
        elseif(jj ==24)
            state = 1;
            setPoint = [-83, 63, -83, 63, 83, -63, 83,-63];
        elseif(jj ==25)
            state = 1;
            setPoint = [-85, 65,-85, 65, 85, -65, 85,-65];
        
        end
        
        
        tp = zeros(2,8);
        tp(1,:) = mod(setPoint + 768, 64);
        tp(2,:) = floor((setPoint + 768) / 64);
        sendingtp = [];
        sendingtp(2:17) = reshape(tp,[1,16]);
        sendingtp(1) = 'S';
        sendingtp(18) = 'E';
        
        fwrite(s , sendingtp);
              'aaaa'
        fwrite(s , sendingtp);
        
        
        tp
        
        tt = 0;
        val = setPoint;
        v = [];
        ts = toc;
        readVal = 0;
        e = [];
        myt = [];
        Anum = 0;
        %% inisial for controling 
        Serror = 0; error = 0; Ki = 0.1 , Kp = 0.3; 
        miliSecendTimeSampling = 100;

        %% loop

        startRead = 1;
        if(jj >1)
            cycle_time = 0.3;
        else
            cycle_time = 20;
        end
        while(tt - ts < cycle_time)
            tt = toc;
            sizeAvailable = s.BytesAvailable;
            if(sizeAvailable >= 18)

                readVal(startRead:startRead+sizeAvailable-1) = fread(s ,sizeAvailable, 'int8');

                i=i+1;
                [y(i,:) , readVal] = decodeEncoders(readVal);
                [startRead, chert] = size(readVal);
                %startRead
                timeCome(i) = tt;
                MysetPoints(i,:) = setPoint;
                state
                y(i,:)
                endPoint_x(i,1) = a*sin(y(i,2)*6.28/768)+b*sin(y(i,2)*6.28/768+y(i,1)*6.28/768);
                endPoint_y(i,1) = -a*cos(y(i,2)*6.28/768)-b*cos(y(i,2)*6.28/768+y(i,1)*6.28/768);
                
                endPoint_x(i,2) = a*sin(y(i,4)*6.28/768)+b*sin(y(i,4)*6.28/768+y(i,3)*6.28/768);
                endPoint_y(i,2) = -a*cos(y(i,4)*6.28/768)-b*cos(y(i,4)*6.28/768+y(i,3)*6.28/768);
                
                endPoint_x(i,3) = a*sin(y(i,6)*6.28/768)+b*sin(y(i,6)*6.28/768+y(i,5)*6.28/768);
                endPoint_y(i,3) = -a*cos(y(i,6)*6.28/768)-b*cos(y(i,6)*6.28/768+y(i,5)*6.28/768);
                
                endPoint_x(i,4) = a*sin(y(i,8)*6.28/768)+b*sin(y(i,8)*6.28/768+y(i,7)*6.28/768);
                endPoint_y(i,4) = -a*cos(y(i,8)*6.28/768)-b*cos(y(i,8)*6.28/768+y(i,7)*6.28/768);
                
                myt(i) = tt;

   
            end

            %drawnow;


        end
    end
    fclose(s)
    delete(s)
    clear s
    [st1 st2] = size(timeCome)
    plot(timeCome ,y(:,4),'b');
    hold on;
    plot(timeCome ,y(:,8),'r');
catch err

    fclose(s)
    delete(s)
    clear s
end