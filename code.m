clear, clc;

% set the position of the figure in the screen
set(gcf, 'Position',  [200, 60, 1000, 700])

% read audio from storage
[y, Fs] = audioread('tanhatarin_ashegh.wav');

% create an audioplayer object from our audio and play it
player = audioplayer(y, Fs);
play(player);

% print size of data (symbols) of our audio file
% our audio has two channels, we just use the first channel
% we will see further that the two channels are the same
y = y(:, 1);
[data_size, x] = size(y);
fprintf('Size of data = %d\n', data_size)

% print the value of FPS of our audio file
fprintf('Fps = %d\n', Fs);

% Calculate the duration of our audio file
fprintf('Audio duration = %f\n', data_size / Fs);

% show the histogram of the audio file with the color green
histogram(y, 'FaceColor', 'magenta');
grid on;

% find the probability of our data
prob = hist(y) / sum(hist(y));

% calculate the entropy value from the probability
enthropy = -sum(prob .* log2(prob));
fprintf("Enthropy = %f\n", enthropy);

% calculate the maximum size we can compress the file by using the first
% Shannon Therory (HN(X))
fprintf("We can compress to %f KB.\n", data_size * enthropy / 8000);

% compress and encode by Huffman code
dict = huffmandict(hist(y), prob);
sig = randsrc(data_size, 1, [hist(y);prob]);
comp = huffmanenco(sig, dict);
comp = comp';
audiowrite('encoded_file.wav', comp, Fs);

% calculate & compare the size of the signals before & after encoding
[x, comp_size] = size(comp);
fprintf("Signal size before encoding: %f KB.\n", data_size / 8000);
fprintf("Signal size after encoding: %f KB.\n", comp_size / 8000);
