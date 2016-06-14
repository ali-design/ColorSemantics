function process_ver2
startup;
beta = 0.01;
gamma = 0.01;
K = 12;
%ALPHA = 0.8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Generate words per each cover from data
read_text_transcription;
read_words_from_Xls_mats;

% Create the word dictionary
[words_vocab] = generate_words_vocab_pruned;

% Generate words input to LDA 
[WS,DS,CS,CDS,noMachWord] = inputLDA_Colors_nd_Words('512','');

% 3.2 LDA on colors and words together
[ WP,DP,Z,CP,CDP,Y ] = myLDA_Colors_nd_Words_1(WS,DS,CS,CDS,K,beta,gamma,WO);

% 3.3 Visualize the results
[titlePortion,topicVsTitle,titleVsTopic] = ...
         visualizeColor_512_LDA_Colors_nd_Words(CP,CDP,Y,imgInxList)
 % for word cloud:
 myWriteTopics_for_Wordcloud( WP , beta , WO , 30 , 1000, './Results/myLDA_Colors_nd_Words_512/K12.txt' );

% Find closest 5-color palettes to k1... k12:
% 1. Create a matrix of 12x512 containing histogram values of each 512 colors in each k
[LDA_palettes_512] = generate_image_from_color_topics_512(CP);
nMatch = 5; % 5 closest 5-color palettes to each k1,..., k12
[distanceCostStruct] = LDA_512_PalMatchBatch(LDA_palettes_512,nMatch);
selectClosestPals_K12(distanceCostStruct);
