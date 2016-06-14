function [WS,DS,CS,CDS,noMachWord] = inputLDA_Colors_nd_Words(colorName,vocabName)

if(strcmp(lower(colorName),'512'))
    [WS,DS,CS,CDS,noMachWord] = inputLDA_colors_512_words_pruned(vocabName);
elseif(strcmp(lower(colorName),'kob'))
    [WS,DS,CS,CDS,noMachWord] = inputLDA_colors_Kob_words(vocabName);
end