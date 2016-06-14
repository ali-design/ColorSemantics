function process_1
startup;
beta = 0.01;
gamma = 0.01;
K = 12;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 1. LDA on words only
% 1.1 Generate words per each cover from data
read_text_transcription;
read_words_from_Xls_mats;

% 1.2 Create the word dictionary
[words_vocab] = generate_words_vocab;

% 1.3 Generate words input to LDA 
[WS,DS] = inputLDA_words_vocab;

% 1.4 LDA on words only
%[WP,DP,Z] = myLDA1(WS,DS,K,beta);
[WP_justWords,DP_justWords,Z_justWords] = myLDA1(WS,DS,K,beta,WO);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Generate Doc: col1 is title of a magazine, col2 is number of this title
[Doc] = generate_Doc;

% 1.4 Visualzie the results
[ S ] = WriteTopics(WP, beta, words_vocab);
WriteTopics(WP, beta, words_vocab, 10, 0.7, 4,...
            'Results/Visualized/topics_justWords.txt' );

visualize_LDA_words(WP,DP,Z,words_vocab,Doc);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 2. LDA on colors only
% 2.1 Index images with color basis (e.g. kobayashi)
[CS,CDS] = inputLDA_colors_basis('Kob');

% 2.2 LDA on colors only
[CP,CDP,Y] = myLDA1_Colors(CS,CDS,K,beta);

% 2.3 Visualize the results
%visualize_LDA_colors(CP,CDP,Y,Doc);
visualize_LDA_colors(CP,CDP,Y,imgInxList);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 3. LDA on colors and words together
% 3.1 Index images with their words and color basis (e.g. kobayashi)
[WS,DS,CS,CDS,noMachWord] = inputLDA_Colors_nd_Words('Kob','year');

% 3.2 LDA on colors and words together
[ WP,DP,Z,CP,CDP,Y ] = myLDA_Colors_nd_Words_1(WS,DS,CS,CDS,K,beta,gamma);

% 3.3 Visualize the results
[titlePortion,topicVsTitle,titleVsTopic] = visualizeColor_vocab_kob(CDS,CP,CDP,Y,'Results/Output_mats/Doc_Colors_nd_Words');
visualize_LDA_Colors_nd_Words(WP,DP,Z,CP,CDP,Y,Doc);

