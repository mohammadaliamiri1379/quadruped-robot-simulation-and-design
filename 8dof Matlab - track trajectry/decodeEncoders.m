function [encoders , str] = decodeEncoders(serialInput)
   encoders = zeros(1,8);
   k = strfind(serialInput,'E');
   mk = max(k);
   if(mk >= 18)
        encoders(1) = serialInput(mk-16) + serialInput(mk-15)*64-768;
        encoders(2) = serialInput(mk-14) + serialInput(mk-13)*64-768;
        encoders(3) = serialInput(mk-12) + serialInput(mk-11)*64-768;
        encoders(4) = serialInput(mk-10) + serialInput(mk-9)*64-768;
        encoders(5) = serialInput(mk-8) + serialInput(mk-7)*64-768;
        encoders(6) = serialInput(mk-6) + serialInput(mk-5)*64-768;
        encoders(7) = serialInput(mk-4) + serialInput(mk-3)*64-768;
        encoders(8) = serialInput(mk-2) + serialInput(mk-1)*64-768;
        
   end
   
   str = serialInput(mk:end);
end

