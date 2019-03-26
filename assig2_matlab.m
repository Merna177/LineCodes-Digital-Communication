%generate Random Signal of length 10 -->zeroes and ones
generated_Signal = randi([0 1],1,10)
%Modulate the Same Signal using Different lines of codes
%Polar NRZ waveform
mapforPolarNRZ = generated_Signal
for i = 1 : length(mapforPolarNRZ)
    if(mapforPolarNRZ(i)== 1)
        mapforPolarNRZ(i) = 1;
    else
        mapforPolarNRZ(i) = -1;
    end
end
%Get the pulse Shape 
%generate pulse signal 
indx = 1;
pulsesinterval = 0:0.01:length(mapforPolarNRZ);
finalPulse = pulsesinterval;
for j = 1:length(pulsesinterval)
%If iam still in the same range of this index 
 if pulsesinterval(j)<=indx
   finalPulse(j) = mapforPolarNRZ(indx);
 else
 %look for the next bit
   indx = indx+1;
   finalPulse(j) = mapforPolarNRZ(indx);
 end
end
%Plotting 
subplot(6,2,1);
plot(pulsesinterval,finalPulse);
title('Polar NotReturntozero');
%begin and start of the plot in y and x axis
axis([0 length(mapforPolarNRZ) -1 1]);
%PSD
%FFT provides us spectrum density( i.e. frequency) of the time-domain signal.  So, PSD  is defined taking square the of absolute value of FFT. 
psd = abs( fft(finalPulse, length(finalPulse))).*2/(length(finalPulse));
subplot(6,2,2);
plot(psd)
title('PSD Polar NotReturntozero');
%%%%%%%%%%%%%%%%%%%%%%%5%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Non return to zero inverted 
%1 ---> y3ks
%0 --> the same as the prev
%shaping
indx = 1;
finalPulseInverted =pulsesinterval
for j = 1:length(pulsesinterval)
  %assume the first pulse well be 1volt
  if j ==1 
    finalPulseInverted(j)=1
    %if iam in the same range repeat
  elseif  finalPulseInverted(j) <= indx
    finalPulseInverted(j)= finalPulseInverted(j-1)
  else 
    indx = indx+1
    %if one * -1 to get the opposite
    if generated_Signal(indx) == 1
       finalPulseInverted(j) = -1*finalPulseInverted(j-1)
    else
    %zero stay as the prev
       finalPulseInverted(j) = finalPulseInverted(j-1)
    end
  end
end
%plotting
subplot(6,2,3);
plot(pulsesinterval,finalPulseInverted);
title('Non return to zero inverted');
axis([0 length(generated_Signal) -1 1]);
%PSD
psd = abs( fft(finalPulseInverted, length(finalPulseInverted))).*2/(length(finalPulseInverted));
subplot(6,2,4);
plot(psd)
title('PSD Non return to zero inverted');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%alternative mark inversion (BIPOLAR)
%mapping
lastvalue=-1
AMI = generated_Signal
for i = 1 : length(AMI)
    if(AMI(i)== 1)
%to make the pulse opposite to the last One
        AMI(i) = -1*lastvalue;
        lastvalue= AMI(i)
    else
        AMI(i) = 0;
    end
end
%Get the pulse Shape 
indx = 1;
AMIfinal = pulsesinterval;
for j = 1:length(pulsesinterval)
 if pulsesinterval(j)<=indx
   AMIfinal(j) = AMI(indx);
 else
   indx = indx+1;
   AMIfinal(j) = AMI(indx);
 end
end
%Plotting
subplot(6,2,5);
plot(pulsesinterval,AMIfinal);
title('AMI');
axis([0 length(AMI) -1 1]);
%PSD
psd = abs( fft(AMIfinal, length(AMIfinal))).*2/(length(AMIfinal));
subplot(6,2,6);
plot(psd)
title('PSD AMI');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MultiLevel
levels  = [1,0,-1]
index=0
%mapping
maplevels = generated_Signal
for i = 1 : length(maplevels)
    if(maplevels(i)== 1)
%to pick the correct value we use mod %
        maplevels(i) = levels(mod(index,3) +1 );
        index+=1
    else
       if i==1
        maplevels(i) = 1 ;
       else 
        maplevels(i) = maplevels(i-1) ;
       end
    end
end
%get shape
indx = 1;
multilevel = pulsesinterval;
for j = 1:length(pulsesinterval)
 if pulsesinterval(j)<=indx
   multilevel(j) = maplevels(indx);
 else
   indx = indx+1;
   multilevel(j) = maplevels(indx);
 end
end
%plotting
subplot(6,2,7);
plot(pulsesinterval,multilevel);
title('Multilevel');
axis([0 length(maplevels) -1 1]);
%PSD
psd = abs( fft(multilevel, length(multilevel))).*2/(length(multilevel));
subplot(6,2,8);
plot(psd);
title('PSD Multilevel');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Polar RZ
mapforPolarRZ = generated_Signal
for i = 1 : length(mapforPolarRZ)
    if(mapforPolarRZ(i)== 1)
        mapforPolarRZ(i) = 1;
    else
        mapforPolarRZ(i) = -1;
    end
end
%we will split index to 2 halfs the first half = mapping bit of signal
%second half will be equal to  zero (if it between 0.5 and index)
indx = 1;
interval1 = 0;
interval2= 0.5;    
finalPulsePolarRZ =pulsesinterval
for j = 1:length(pulsesinterval)
        if pulsesinterval(j)>=interval1 && pulsesinterval(j)<=interval2
            finalPulsePolarRZ(j) = mapforPolarRZ(indx);
        elseif pulsesinterval(j)>interval2 && pulsesinterval(j)<indx
            finalPulsePolarRZ(j) = 0;
        else
            indx = indx+1;
            interval1 = interval1+1;
            interval2 = interval2+1;
            finalPulsePolarRZ(j) = finalPulsePolarRZ(j-1);
        end
    end
%plotting
subplot(6,2,9);
plot(pulsesinterval,finalPulsePolarRZ);
title('Polar RZ');
axis([0 length(mapforPolarRZ) -1 1]);
%PSD
psd = abs( fft(finalPulsePolarRZ, length(finalPulsePolarRZ))).*2/(length(finalPulsePolarRZ));
subplot(6,2,10);
plot(psd);
title('PSD Polar RZ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Manchester Code
%mapping 
%mapping one with one because it  starts from high to low
%zero with negative 1 bec. it goes from low to high
mapformanchester = generated_Signal
for i = 1 : length(mapformanchester)
    if(mapformanchester(i)== 1)
        mapformanchester(i) = 1;
    else
        mapformanchester(i) = -1;
    end
end
%pulse
%after 0.5 in 1 i will make the edge falling
indx = 1;
interval1 = 0;
interval2= 0.5;

finalPulsemanchester =pulsesinterval
for j = 1:length(pulsesinterval)
        if pulsesinterval(j)>=interval1 && pulsesinterval(j)<=interval2
            finalPulsemanchester(j) = mapformanchester(indx);
        elseif pulsesinterval(j)>interval2 && pulsesinterval(j)<indx
            finalPulsemanchester(j) = -1*mapformanchester(indx);
        else
            indx = indx+1;
            interval1 = interval1+1;
            interval2 = interval2+1;
            finalPulsemanchester(j) = finalPulsemanchester(j-1);
        end
end
%plotting
subplot(6,2,11);
plot(pulsesinterval,finalPulsemanchester);
title('manchester');
axis([0 length(mapformanchester) -1 1]);
%PSD
psd = abs( fft(finalPulsemanchester, length(finalPulsemanchester))).*2/(length(finalPulsemanchester));
subplot(6,2,12);
plot(psd);
title('PSD Polar RZ');
