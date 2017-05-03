
% Realtime vocoder script
% realtime audio processing done using the Matlab DSP
% object (probable requirements are Matlab 2015, the DSP
% toolbox, maybe also data acquisition toolbox + support
% package for Windows sound cards)

%% user parameters

fs = 44100; 
%sampling freq.

carrFile = '';
%Sound file containing the instrument (carrier). 
%If you want to use real-time instrument input, modify this script or
%contact us.

framelen = 2048;
%Length of the input buffer in nr of samples. Set as low as possible to reduce latency, but
%not too low to avoid glitches (clicks and pops in audio signal).

duration = 10;
%nr of seconds the vocoder should run.

soundCardName = 'Default';
%Name of device for recording and playback.
%Usually 'Default'. If you have an audio interface with ASIO drivers, use
%this to reduce latency.
%See dsp.AudioRecorder or dsp.AudioPlayer for more info

windowLength = 50e-3;
%Length of the window in seconds.
%The length of the window in samples cannot be larger than framelen. If a
%windowLength is given that results in a larger length, it will be
%truncated to framelen.

lpcOrder = 14;
%Order of the linear prediction.



%% initialize

% source initialisation: sound card input (modulator)
src1 = dsp.AudioRecorder('DeviceName',soundCardName, 'QueueDuration',2*(framelen+1)/fs,'OutputNumOverrunSamples',true,... %2*(framelen+1)/fs
    'BufferSizeSource','Property', 'BufferSize',framelen,'SamplesPerFrame',framelen, 'NumChannels',1);%'SampleRate',16000);

% source initialisation: file input (carrier)
src2 = dsp.AudioFileReader('Filename',carrFile,'SamplesPerFrame',framelen);

% sink initialisation: sound card output (Default device)
sink1 = dsp.AudioPlayer('DeviceName',soundCardName,'QueueDuration',2*(framelen+1)/fs,... %2*(framelen+1)/fs
    'BufferSizeSource','Property', 'BufferSize',framelen, 'OutputNumUnderrunSamples',true);%'SampleRate',16000);

nframes = duration*fs/framelen;

Nwin = round((windowLength*fs));
Nwin = min(Nwin,framelen);
Nwin = Nwin+(1-mod(Nwin,2)); %make length odd for COLA
Nhop = (Nwin-1)/2;
win = hann(Nwin);


outputFrameLength = Nwin;

inputFrame = zeros(Nwin,1);
inputFrameCarr = zeros(Nwin,1);
inputIndex = 1;
inputFrameIndex = Nwin-Nhop+1;
outputBuffLength = framelen+outputFrameLength-1;
outputBuff = zeros(outputBuffLength,1);
outputBuffIndex = Nhop+1;
outputBuff2 = zeros(framelen,1);


%% Stream processing loop.

for ii = 1:nframes

    if isDone(src2)
        break
    end
    %read an audio block from the soundcard input (modulator)    
    in1 = step(src1);
    %read an audio block from the instrument (carrier) file  
    in2 = step(src2);
    
    % Call user Algorithm   
    while inputIndex<=framelen
        nrSamplesCopy = min(framelen-inputIndex+1,Nwin-inputFrameIndex+1); %nr samples in input frame, nr samples needed to fill processing frame
        inputFrame(inputFrameIndex:inputFrameIndex+nrSamplesCopy-1) = in1(inputIndex:inputIndex+nrSamplesCopy-1);
        inputFrameCarr(inputFrameIndex:inputFrameIndex+nrSamplesCopy-1) = in2(inputIndex:inputIndex+nrSamplesCopy-1);
        inputIndex = inputIndex + nrSamplesCopy;
        inputFrameIndex = inputFrameIndex + nrSamplesCopy;
        if inputFrameIndex > Nwin %buffer full
            
         outputFrame = vocodeLPC(win.*inputFrame,win.*inputFrameCarr,lpcOrder);
         
         outputBuff(outputBuffIndex:outputBuffIndex+outputFrameLength-1) = outputBuff(outputBuffIndex:outputBuffIndex+outputFrameLength-1) + outputFrame;
         outputBuffIndex = outputBuffIndex + Nhop;         
         
         if outputBuffIndex>framelen
             outputBuff2 = outputBuff(1:framelen);
             outputBuff(1:length(outputBuff)-framelen) = outputBuff(framelen+1:length(outputBuff));
             outputBuff(length(outputBuff)-framelen+1:end) = 0;
             outputBuffIndex = outputBuffIndex - framelen;
         end
         
         inputFrame(1:Nwin-Nhop)=inputFrame(1+Nhop:Nwin);
         inputFrameCarr(1:Nwin-Nhop)=inputFrameCarr(1+Nhop:Nwin);
         inputFrameIndex = Nwin-Nhop+1;
        end
    end
    inputIndex = 1;   
    out1 = [outputBuff2 outputBuff2];

    % send the processed audio block to the soundcard output
    step(sink1,out1);
    
    
end
% Clean up
release(src1);
release(src2);
release(sink1);


