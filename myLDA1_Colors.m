function [ CP,CDP,Y ] = myLDA1_Colors(CS,CDS,K,beta)

%% Example 1 of running basic topic model (LDA)
%
% This example shows how to run the LDA Gibbs sampler on a small dataset to
% extract a set of topics and shows the most likely words per topic. It
% also writes the results to a file
startup;
%%
% Choose the dataset



%%
% Set the number of topics
T=K; 

%%
% Set the hyperparameters
BETA=beta;
ALPHA=10/T; % set less than 1

%%
% The number of iterations
N = 300; 

%%
% The random seed
SEED = 3;

%%
% What output to show (0=no output; 1=iterations; 2=all output)
OUTPUT = 1;

%%
% This function might need a few minutes to finish
tic
[ CP,CDP,Y ] = GibbsSamplerLDA( CS , CDS , T , N , ALPHA , BETA , SEED , OUTPUT );
toc

