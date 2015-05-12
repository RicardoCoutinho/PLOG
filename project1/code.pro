%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                BIBLIOTECAS                   %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- use_module(library(lists)).
:- use_module(library(random)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%              VARIAVEIS GLOBAIS               %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:-dynamic
    flag_size/1,
    flag_wall/1,
    flag_chain/1,
    flag_piece/1,
    flag_rotate/1,
    flag_mode/1,       
    player1/1,
    player2/1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                    FACTOS                    %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

player(empty).
player(player1).
player(player2).

orientation(empty).
orientation(vertical).
orientation(horizontal).

status(free).
status(used).
status(next).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                ENTRY POINT                   %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

init :-
    retractall(flag_size(_)),
    assert(flag_size(6)),

    retractall(flag_wall(_)),
    assert(flag_wall(true)),

    retractall(flag_chain(_)),
    assert(flag_chain(3)),

    retractall(flag_piece(_)),
    assert(flag_piece(5)),

    retractall(flag_rotate(_)),
    assert(flag_rotate(false)), 

    retractall(flag_mode(_)), 
    assert(flag_mode(easy)),

    retractall(player1(_)),
    assert(player1(jogador1)),

    retractall(player2(_)),
    assert(player2(jogador2)),

    menu_init.

start :- 
    flag_size(X),
    flag_piece(N),
    
    build(X,X,MP,MV), 
    print_board(MP,MV),
    play(N,MP,MV).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%                   JOGO                       %%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% play(+NTurns,+MatrixPieces,+MatrixValues)
play(N,MP,MV) :-
    N > 0, N1 is N-1,
            
    turn(player1,MV,MP,MP2),  is_any_moves_left(MP2),
    turn(player2,MV,MP2,MP3), is_any_moves_left(MP3),
    
    play(N1,MP3,MV).

play(_,MP,MV) :- show_result(MP,MV).


% turn(+Player,+MatrixValues,+Matrix,-Matrix2)
turn(Player,MV,M,M4) :- % turn with computer playing        
    is_computer(Player),
    msg_name(computer),
    flag_mode(Mode),
    placement_computer(Mode,Player,MV,M,M2), msg_place, print_board(M2,MV),

    flag_chain(N),
    chainreaction(N,M2,M3), msg_chain, print_board(M3,MV),
    clear(M3,M4).   

turn(Player,MV,M,M4) :-
    placement(Player,M,M2), msg_place, print_board(M2,MV), 
    
    flag_chain(N), 
    chainreaction(N,M2,M3), msg_chain, print_board(M3,MV),
    clear(M3,M4).

% placement(+Player,+Matrix,-MatrixOut)
placement(Player,M,M2) :-  
    Player = player1, player1(Name),
    msg_turn(Name),
    question(A),
    process_placement(Player,A,M,M2).

placement(Player,M,M2) :-  
    Player = player2, player2(Name),
    msg_turn(Name),
    question(A),
    process_placement(Player,A,M,M2).
                                 
placement(Player,M,M2) :- msg_erro2, placement(Player,M,M2).
 

% placement_computer(+Mode,+Player,+MatrixValues,+Matrix,-MatrixOut)
placement_computer(easy,Player,_,M,M2) :-
    get_all(free,M,[(X,Y)|_]),
    random(1,3,Oi), orientation_from_number(Oi,O),
    P = [Player,O,next],
    set(P,X,Y,M,M2).
     
placement_computer(normal,Player,_,M,M2) :-
    get_all(free,M,L), length(L,Max), Max1 is Max+1,
    random(1,Max1,I),  nth1(I,L,(X,Y)),
    random(1,3,Oi),    orientation_from_number(Oi,O),
    P = [Player,O,next],
    set(P,X,Y,M,M2).                          

placement_computer(hard,Player,_,M,M2) :-        
    get_all(free,M,L), length(L,Max), Max1 is Max+1,
    random(1,Max1,I),  nth1(I,L,(X,Y)),
    random(1,3,Oi),    orientation_from_number(Oi,O),
    P = [Player,O,next],
    set(P,X,Y,M,M2).     

placement_computer(impossibru,Player,_,M,M2) :-
    get_all(player1,M,L), length(L,Max), Max1 is Max+1,
    random(1,Max1,I),     nth1(I,L,(X,Y)),
    random(1,3,Oi),       orientation_from_number(Oi,O),
    P = [Player,O,next],
    set(P,X,Y,M,M2).

placement_computer(impossibru,Player,_,M,M2) :-
    get_all(free,M,L), length(L,Max), Max1 is Max+1,
    random(1,Max1,I),  nth1(I,L,(X,Y)),
    random(1,3,Oi),    orientation_from_number(Oi,O),
    P = [Player,O,next],
    set(P,X,Y,M,M2).


% chainreaction(+NChains,+Matrix,-MatrixOut)
chainreaction(N,M,M3) :-
    N > 0, N1 is N-1,
    get_all(next,M,L), \+ is_empty_list(L),
    chain_all(L,M,M2),
    chainreaction(N1,M2,M3).

chainreaction(0,M,M). 

chainreaction(_,M,M).


% chain_all(+XYList,+Matrix,-MatrixNew)
chain_all([XY|XYs],M,M3) :- 
    chain(XY,M,M2),
    chain_all(XYs,M2,M3).

chain_all([],M,M).


% chain(+XYTuple,+Matrix,-MatrixNew)
chain((X,Y),M,M2) :- % chain horizontal
    P = [Player,horizontal,next],  
    P2 =[Player,horizontal,used],
            
    append(Ma,[L|Mz],M),    length(Ma,Y1), Y1 is Y-1,
    append(La,[P|Lz],L),    length(La,X1), X1 is X-1,
    append(Ma,[L2|Mz],M2),
    append(La2,[P2|Lz2],L2),
    
    reverse(La,RevLa),
    reverse(RevLa2,La2),
    
    push(RevLa,RevLa,[],RevLa2),
    push(Lz,Lz,[],Lz2).  

chain((X,Y),M,M2) :- % chain vertical
    P = [Player,vertical,next],  
    P2 =[Player,vertical,used],
            
    append(Ma,[L|Mz],MI),   length(Ma,Y1),     Y1 is X-1, transpose(M,MI),
    append(La,[P|Lz],L),    length(La,X1),     X1 is Y-1,
    append(Ma,[L2|Mz],MI2), transpose(MI2,M2),
    append(La2,[P2|Lz2],L2),
    
    reverse(La,RevLa),
    reverse(RevLa2,La2),
    
    push(RevLa,RevLa,[],RevLa2),
    push(Lz,Lz,[],Lz2).


% push(+OriginalList,+NextElementList,+DoneElementList,-Result)
push(L,[],[],L).

push(L,[],_,L) :- flag_wall(true).

push(_,[],[_|Xs],[[empty,empty,free]|Xs]) :- flag_wall(false).

push(L,[[empty,_,_]|_],[],L).

push(L,[[_,_,used]|_],_,L).

push(L,[[_,_,next]|_],_,L).

push(_,[[empty,empty,free]|T],Pushed,L2) :- reverse(Pushed,RevPushed), append([[empty,empty,free]|RevPushed],T,L2).

push(L,[[P,O,_]|T],Pushed,L2) :- push(L,T,[[P,O,next]|Pushed],L2).
  
             
% show_result(+MatrixPieces,+MatrixValues)
show_result(MP,MV) :- 
    msg_sep,
    print_board(MP,MV),        
    get_score(MP,MV,0,0,Score1,Score2), nl,        
    msg_winner,
    write('                  '), player1(X), write(X), write(': '), write(Score1), write(' pontos'), nl,
    write('                  '), player2(Y), write(Y), write(': '), write(Score2), write(' pontos'), nl,
    nl,
    show_winner(Score1,Score2).


% get_score(+MatrixPieces, +MatrixValues,+P1Counter,+P2Counter,-P1Score,-P2Score)
get_score([LP|LPs],[LV|LVs],P1Incr,P2Incr,P1Score,P2Score) :-
    get_score_list(LP,LV,P1Incr,P2Incr,P1ListScore,P2ListScore),
    get_score(LPs,LVs,P1ListScore,P2ListScore,P1Score,P2Score).

get_score([],[],P1Score,P2Score,P1Score,P2Score).


% get_score_list(+ListPieces, +ListValues,+P1Counter,+P2Counter,-P1Score,-P2Score)
get_score_list([[player1,_,_]|T],[V|Vs],P1Incr,P2Incr,P1Score,P2Score) :- 
    P1Incr2 is P1Incr+V,
    get_score_list(T,Vs,P1Incr2,P2Incr,P1Score,P2Score).

get_score_list([[player2,_,_]|T],[V|Vs],P1Incr,P2Incr,P1Score,P2Score) :- 
    P2Incr2 is P2Incr+V,
    get_score_list(T,Vs,P1Incr,P2Incr2,P1Score,P2Score).

get_score_list([[empty,_,_]|T],[_|Vs],P1Incr,P2Incr,P1Score,P2Score) :- get_score_list(T,Vs,P1Incr,P2Incr,P1Score,P2Score).

get_score_list([],[],P1Score,P2Score,P1Score,P2Score).   


% show_winner(+Score1,+Score2)
show_winner(Score1,Score2) :- 
    Score1 > Score2,        
    write('               O vencedor:  '), player1(A), write(A),  nl,nl,nl,nl.
   
show_winner(Score1,Score2) :- 
    Score1 < Score2,
    write('               O vencedor:  '), player2(A), write(A),  nl,nl,nl,nl.

show_winner(Score1,Score2) :- 
    Score1 =:= Score2,
    write('               Empate !!!'),  nl,nl,nl,nl.         


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%                   MENUS                      %%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

menu_init :-
    msg_init,
    question(A),
    process_init(A).

menu_main :- 
    msg_main,
    question(A),
    process_main(A).

menu_mode :-
    msg_mode,
    question(A),
    process_mode(A).
        
menu_config :-
    msg_config,
    question(A),
    process_config(A).

menu_config_1 :-
    msg_config_1,
    question(A),
    process_config_1(A).

menu_config_4 :-
    msg_config_4,
    question(A),
    process_config_4(A).

menu_config_5 :-
    msg_config_5,
    question(A),
    process_config_5(A).


% question(-Input)
question(Answer) :- nl,write(' :?: '),read_line(Answer),nl.


% process_init(+Input)
process_init(_) :- menu_main.


% process_main(+Input)
process_main([48|_]).

process_main([49|_]) :- player1(X), player2(Y), retract(player1(X)), retract(player2(Y)), assert(player1(jogador1)),    assert(player2(jogador2)),    start.      

process_main([50|_]) :- player1(X), player2(Y), retract(player1(X)), retract(player2(Y)), assert(player1(jogador)),     assert(player2(computador)),  menu_mode.      

process_main([51|_]) :- player1(X), player2(Y), retract(player1(X)), retract(player2(Y)), assert(player1(computador1)), assert(player2(computador2)), menu_mode.      

process_main([52|_]) :- msg_regras, question(_), menu_main.

process_main([53|_]) :- menu_config.

process_main(_)      :- msg_erro, menu_main.


% process_mode(+Input)
process_mode([48|_]) :- menu_main.

process_mode([49|_]) :- flag_mode(X), retract(flag_mode(X)), assert(flag_mode(easy)),       start.

process_mode([50|_]) :- flag_mode(X), retract(flag_mode(X)), assert(flag_mode(normal)),     start.

process_mode([51|_]) :- flag_mode(X), retract(flag_mode(X)), assert(flag_mode(hard)),       start.

process_mode([52|_]) :- flag_mode(X), retract(flag_mode(X)), assert(flag_mode(impossibru)), start.

process_mode(_)      :- msg_erro, menu_mode.


% process_config(+Input)
process_config([48|_]) :- menu_main.

process_config([49|_]) :- menu_config_1.

process_config([50|_]) :- flag_wall(true),    retract(flag_wall(true)),    assert(flag_wall(false)),   menu_config.

process_config([50|_]) :- flag_wall(false),   retract(flag_wall(false)),   assert(flag_wall(true)),    menu_config.

process_config([51|_]) :- flag_rotate(true),  retract(flag_rotate(true)),  assert(flag_rotate(false)), menu_config.

process_config([51|_]) :- flag_rotate(false), retract(flag_rotate(false)), assert(flag_rotate(true)),  menu_config.

process_config([52|_]) :- menu_config_4.

process_config([53|_]) :- menu_config_5.

process_config(_)      :- msg_erro, menu_config.
      
     
% process_config_1(+Input)
process_config_1([48|_]) :- menu_config.

process_config_1([97|_]) :- flag_size(X), retract(flag_size(X)), assert(flag_size(6)), menu_config.

process_config_1([98|_]) :- flag_size(X), retract(flag_size(X)), assert(flag_size(7)), menu_config.

process_config_1([99|_]) :- flag_size(X), retract(flag_size(X)), assert(flag_size(8)), menu_config.

process_config_1([100|_]):- flag_size(X), retract(flag_size(X)), assert(flag_size(9)), menu_config.

process_config_1(_)      :- msg_erro, menu_config_1.


% process_config_4(+Input)
process_config_4([48|_]) :- menu_config.

process_config_4([97|_]) :- flag_piece(X), retract(flag_piece(X)), assert(flag_piece(5)),  menu_config.

process_config_4([98|_]) :- flag_piece(X), retract(flag_piece(X)), assert(flag_piece(15)), menu_config.

process_config_4([99|_]) :- flag_piece(X), retract(flag_piece(X)), assert(flag_piece(20)), menu_config.

process_config_4([100|_]):- flag_piece(X), retract(flag_piece(X)), assert(flag_piece(35)), menu_config.

process_config_4(_)      :- msg_erro, menu_config_4.
    

% process_config_5(+Input)
process_config_5([48|_]) :- menu_config.

process_config_5([97|_]) :- flag_chain(X), retract(flag_chain(X)), assert(flag_chain(0)),  menu_config.

process_config_5([98|_]) :- flag_chain(X), retract(flag_chain(X)), assert(flag_chain(3)),  menu_config.

process_config_5([99|_]) :- flag_chain(X), retract(flag_chain(X)), assert(flag_chain(6)),  menu_config.

process_config_5([100|_]):- flag_chain(X), retract(flag_chain(X)), assert(flag_chain(90)), menu_config.

process_config_5(_)      :- msg_erro, menu_config_5.


% process_placement(+Player,+Input,+Matrix,-MatrixOut)
process_placement(Player,[O,SPACE,X,SPACE,Y|_],M,M2) :-
    SPACE = 32, is_number(X), is_number(Y), orientation_from_code(O,O2),
    X2 is X-48, Y2 is Y-48,
    is_empty(X2,Y2,M), set([Player,O2,next],X2,Y2,M,M2).


msg_init :-
    nl,nl,nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    write('%%%%%%%%%%                                              %%%%%%%%%%'), nl,
    write('%%%%%%%%%%                 Pushee Pieces                %%%%%%%%%%'), nl,
    write('%%%%%%%%%%                                              %%%%%%%%%%'), nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    nl,nl,nl,
    write('    Desenvolvido por: '), nl, 
    write('         ei12130 - Eduardo Fernandes'), nl,
    write('         ei12161 - José Ricardo Coutinho'), nl,
    nl,
    write('    No ambito de: '), nl,
    write('         Programacao em Logica'), nl,
    write('         do Mestrado Integrado em Engenharia Informatica'), nl,
    nl,nl,nl,nl,
    write('               PRESSIONE QUALQUER TECLA PARA INICIAR'),
    nl,nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    nl.


msg_main :-
    nl,nl,nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    write('%%%%%%%%%%                                              %%%%%%%%%%'), nl,
    write('%%%%%%%%%%                      Menu                    %%%%%%%%%%'), nl,
    write('%%%%%%%%%%                                              %%%%%%%%%%'), nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    nl,nl,nl,
    write('                 1 ) Jogador     VS  Jogador'), nl, 
    write('                 2 ) Jogador     VS  Computador'), nl,
    write('                 3 ) Computador  VS  Computador'), nl,
    nl,
    write('                 4 ) Regras'), nl,
    write('                 5 ) Configuracoes'), nl,
    nl,
    write('                 0 ) Sair'), nl,
    nl,nl,nl,nl,
    write('                        SELECIONE UMA OPCAO'),
    nl,nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    nl.


msg_mode :-
    nl,nl,nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    write('%%%%%%%%%%                                              %%%%%%%%%%'), nl,
    write('%%%%%%%%%%                   Dificuldade                %%%%%%%%%%'), nl,
    write('%%%%%%%%%%                                              %%%%%%%%%%'), nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    nl,nl,nl,
    write('                 1 ) Easy'), nl, 
    write('                 2 ) Normal'), nl,
    write('                 3 ) Hard'), nl,
    write('                 4 ) Impossibru'), nl,
    nl,
    write('                 0 ) Voltar ao menu principal'), nl,
    nl,
    nl,nl,nl,nl,
    write('                        SELECIONE UMA OPCAO'),
    nl,nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    nl.


msg_config :-
    nl,nl,nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    write('%%%%%%%%%%                                              %%%%%%%%%%'), nl,
    write('%%%%%%%%%%                 Configuracoes                %%%%%%%%%%'), nl,
    write('%%%%%%%%%%                                              %%%%%%%%%%'), nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    nl,nl,nl,
    write('                 1 ) Tamanho do tabuleiro : '), flag_size(A),   write(A), write('x'),write(A), nl, 
    write('                 2 ) Colisao com parede   : '), flag_wall(B),   write(B), nl,
    write('                 3 ) Rotacao de pecas     : '), flag_rotate(C), write(C), nl,
    write('                 4 ) Numero de pecas      : '), flag_piece(D),  write(D), nl,
    write('                 5 ) Numero de cadeias    : '), flag_chain(E),  msg_config_5_aux(E), nl,
    nl,
    write('                 0 ) Voltar ao menu principal'), nl,
    nl,
    nl,nl,nl,
    write('                        SELECIONE UMA OPCAO'),
    nl,nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    nl.


msg_config_1 :-
    nl,nl,nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    write('%%%%%%%%%%                                              %%%%%%%%%%'), nl,
    write('%%%%%%%%%%                 Configuracoes                %%%%%%%%%%'), nl,
    write('%%%%%%%%%%                                              %%%%%%%%%%'), nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    nl,nl,nl,
    write('                 1 ) Tamanho do tabuleiro : '), flag_size(A), write(A),write('x'),write(A),  nl, 
    write('                     a ) 6x6 '), nl,
    write('                     b ) 7x7 '), nl,
    write('                     c ) 8x8 '), nl,
    write('                     d ) 9x9 '), nl,
    nl,
    write('                 0 ) Voltar atras'), nl,
    nl,
    nl,nl,nl,
    write('                        SELECIONE UMA OPCAO'),
    nl,nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    nl.


msg_config_4 :-
    nl,nl,nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    write('%%%%%%%%%%                                              %%%%%%%%%%'), nl,
    write('%%%%%%%%%%                 Configuracoes                %%%%%%%%%%'), nl,
    write('%%%%%%%%%%                                              %%%%%%%%%%'), nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    nl,nl,nl,
    write('                 4 ) Numero de pecas : '), flag_piece(D), write(D),  nl, 
    write('                     a )  5 '), nl,
    write('                     b ) 15 '), nl,
    write('                     c ) 20 '), nl,
    write('                     d ) 35 '), nl,
    nl,
    write('                 0 ) Voltar atras'), nl,
    nl,
    nl,nl,nl,
    write('                        SELECIONE UMA OPCAO'),
    nl,nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    nl.


msg_config_5 :-
    nl,nl,nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    write('%%%%%%%%%%                                              %%%%%%%%%%'), nl,
    write('%%%%%%%%%%                 Configuracoes                %%%%%%%%%%'), nl,
    write('%%%%%%%%%%                                              %%%%%%%%%%'), nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    nl,nl,nl,
    write('                 5 ) Numero de cadeias : '), flag_chain(E), msg_config_5_aux(E),  nl, 
    write('                     a ) 0 '), nl,
    write('                     b ) 3 '), nl,
    write('                     c ) 6 '), nl,
    write('                     d ) ilimitado '), nl,
    nl,
    write('                 0 ) Voltar atras'), nl,
    nl,
    nl,nl,nl,
    write('                        SELECIONE UMA OPCAO'),
    nl,nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    nl.


% msg_config_5_aux(+Number)
msg_config_5_aux(90) :-
    write('ilimitado').

msg_config_5_aux(X) :-
    write(X).


msg_regras :- nl,nl,nl,
    write(' REGRAS: '),nl,nl,
    write(' - O objectivo do jogo é obter mais pontos que o outro jogador.'),nl,
    write(' - A pontuação de cada jogador é contabilizada no final e é igual'),nl,
    write('   à soma do valores das quadriculas em que as peças desse jogador'),nl,
    write('   se encontram.'),nl,
    write(' - As peças só podem ser colocadas na vertical ou horizontal.'), nl,
    write(' - As peças podem empurrar na direção dos seus extremos.'),nl,nl,
    write(' As restantes regras são aprendidas jogando. Boa sorte!'),nl,nl,nl,nl,
    write('   PRESSIONE QUALQUER TECLA PARA SAIR'),nl,nl.


msg_erro :-
    nl, write(' OPCAO INVALIDA, tente outra vez.'), nl, nl.

msg_erro2 :-
    nl, write(' JOGADA INVALIDA, tente outra vez.'), nl, nl.


msg_turn(Name) :- 
    nl, nl ,write('%%%%%%%%%%%%%%%%%%%%%%%%%%%[ '),write(Name) , write(' ]%%%%%%%%%%%%%%%%%%%%%%%%%%% '),nl, nl,
    write('   Tipos de Orientacao :: (v)ertical (h)orizontal'), nl, nl,
    write('   Introduza as suas opcoes no seguinte formato :: orientacao coordenada_X coordenada_Y'),nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl.

msg_name(Name) :- 
    nl, nl , nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%[ '),write(Name) , write(' ]%%%%%%%%%%%%%%%%%%%%%%%%%%% '),nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%').

msg_winner :-
    nl,nl,nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    write('%%%%%%%%%%                                              %%%%%%%%%%'), nl,
    write('%%%%%%%%%%                   Resultado                  %%%%%%%%%%'), nl,
    write('%%%%%%%%%%                                              %%%%%%%%%%'), nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
    nl,nl,nl. 

msg_sep :-
    nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl.

msg_place :-
    nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%  Colocacao  %%%%%%%%%%%%%%%%%%%%%%%%%%'), nl.

msg_chain :-
    nl,nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Cadeia   %%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%                  CONSTRUCAO                  %%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% build(+Width,+Height,-MatrixPieces,-MatrixValues)
build(W,H,MatrixPieces,MatrixValues) :-
    build_board(W,H,build_element,MatrixPieces),
    build_board(W,H,build_value,MatrixValues).


% build_board(+Width,+Height,+Predicate,-Matrix)
build_board(W,H,Pred,M) :-
    H > 0,
    length(M,H),
    maplist(build_line(W,Pred),M).        


% build_line(+Width,-List)
build_line(W,Pred,L) :-
    W > 0,
    length(L,W),
    maplist(Pred,L). 


% build_element(?Element)
build_element(E) :-
    E = [empty,empty,free].


% build_value(?Value)
build_value(V) :-
    random(0,10,V).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%          VISUALIZAÇAO DO TABULEIRO           %%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% print_board(+MatrixPieces,+MatrixValues)
print_board(MP,MV) :- nl,
    head(MP,L), length(L,Width),
    write('   '), print_guide(1,Width),nl,                            
                  print_rows(1,Width,MP,MV),
    write('   '), print_border(Width), nl.


% print_guide(+StartingNumber,+Width)
print_guide(N0,N) :- 
    N0 > 0, N0 =< N, N1 is N0+1,
    write('    '), write(N0), write('   '),
    print_guide(N1,N).
print_guide(N0,N) :- N0 > N.
    

% print_rows(+StartingNumber,+Width,+MatrixPieces,+MatrixValues)
print_rows(N,W,[H|T],[H2|T2]) :-
    write('   '), print_border(W), nl,
                  print_row(N,H,H2),
    N1 is N+1,    print_rows(N1,W,T,T2).
print_rows(_,_,[],[]).
    

% print_border(+Width)
print_border(N) :- 
    N > 0, N1 is N-1,
    write('+-------'),
    print_border(N1).
print_border(0) :- write('+').


% print_row(+Number,+ListPieces,+ListValues)
print_row(N,LP,LV) :-
    write('   '),                     print_rowH(1,LP,LV), nl,
    write(' '), write(N), write(' '), print_rowH(2,LP,LV), nl,
    write('   '),                     print_rowH(3,LP,LV), nl.


% print_row(+Height,+ListPieces,+ListValues)
print_rowH(Y,[H|T],[H2|T2]) :-
    print_cell(Y,H,H2),
    print_rowH(Y,T,T2).
print_rowH(_,[],[]) :- write('|').


% print_cell(+Height,+[Player,Orientation,Turn],+Value)
print_cell(1,[empty|_],_)              :- write('|       ').
print_cell(1,[player1,vertical|_],_)   :- write('|   X   ').
print_cell(1,[player2,vertical|_],_)   :- write('|   O   ').
print_cell(1,[player1,horizontal|_],_) :- write('|       ').
print_cell(1,[player2,horizontal|_],_) :- write('|       ').

print_cell(2,[empty|_],_)              :- write('|       ').
print_cell(2,[player1,vertical|_],_)   :- write('|   X   ').
print_cell(2,[player2,vertical|_],_)   :- write('|   O   ').
print_cell(2,[player1,horizontal|_],_) :- write('| XXXXX ').
print_cell(2,[player2,horizontal|_],_) :- write('| OOOOO ').
        
print_cell(3,[empty,_|_],V)            :- write('|      '), print_value(V).
print_cell(3,[player1,vertical|_],V)   :- write('|   X  '), print_value(V).
print_cell(3,[player2,vertical|_],V)   :- write('|   O  '), print_value(V).
print_cell(3,[player1,horizontal|_],V) :- write('|      '), print_value(V).
print_cell(3,[player2,horizontal|_],V) :- write('|      '), print_value(V).


% print_value(+Value)
print_value(V) :- V > 0, write(V).
print_value(0) :- write(' ').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%                  CONDICOES                   %%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% is_computer(+Player)
is_computer(player1) :-
    player1(X), X = computador1.

is_computer(player2) :-
    player2(X), X = computador.

is_computer(player2) :-
    player2(X), X = computador2.


% is_empty_list(+L)
is_empty_list([]).


% is_inside(+X,+Y,+Matrix)
is_inside(X,Y,M) :- 
    size(M,LX,LY),
    X > 0, X =< LX,
    Y > 0, Y =< LY.

% is_empty(+X,+Y,+Matrix)
is_empty(X,Y,M) :-
    get(X,Y,M,[empty,_,_]).


% is_number(+Code)
is_number(Code) :-
    Code >= 48 ,
    Code =< 57.  

% is_any_moves_left(+Matrix)
is_any_moves_left(M) :-
    get_all(empty,M,L),
    \+ is_empty_list(L).
        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%                  OPERACO•ES                   %%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% size(+Matrix,-X,-Y)
size(M,X,Y) :-
    length(M,Y),
    head(M,H),
    length(H,X).
  
      
% get(+X,+Y,+Matrix,-Piece)
get(X,Y,M,P) :-
    is_inside(X,Y,M),
    X1 is X-1, Y1 is Y-1,
    append(Ma,[L|_],M), length(Ma,Y1),
    append(La,[P|_],L), length(La,X1).


% get_all(+Status,+Matrix,-List)
get_all(Status,M,L) :-
    setof( (X,Y), ( nth1(Y,M,Row), nth1(X,Row,P), member(Status,P) ), L).

get_all(_,_,[]).

   
% get_all_except(+Status,+Matrix,-List)
get_all_except(Status,M,L) :- 
    setof( (X,Y) , ( nth1(Y,M,Row), nth1(X,Row,P), \+ member(Status,P))  , L).

get_all_except(_,_,[]).


% set(+Piece,+X,+Y,+Matrix,-Matrix2)
set(P,X,Y,M,M2) :-
    is_inside(X,Y,M),
    append(Ma,[L|Mz],M),   length(Ma,Y1), Y1 is Y-1,
    append(La,[_|Lz],L),   length(La,X1), X1 is X-1,
    append(Ma,[L2|Mz],M2),
    append(La,[P|Lz],L2).


% empty(+X,+Y,+Matrix,-Matrix2)
empty(X,Y,M,M2) :- P = [empty,empty,free], set(P,X,Y,M,M2).


% move(+Xa,+Ya,+Xb,+Yb,+Matrix,-Matrix2)
move(Xa,Ya,Xb,Yb,M,M2) :-
    is_empty(Xb,Yb,M),
    get(Xa,Ya,M,P), 
    empty(Xa,Ya,M,Maux),
    set(P,Xb,Yb,Maux,M2).
        

% clear(+Matrix,-Matrix2)
clear(M,M2) :- maplist(maplist(clear_turn),M,M2).


% clear_turn(+Piece,-Piece2)
clear_turn([P,O,_],[P,O,free]).


% stamp_and_reverse(+PieceList,-PieceList)
stamp_and_reverse([[P,O,_]|T],L) :- stamp_and_reverse(T,[[P,O,next]|L]).

stamp_and_reverse([],[]).


% orientation_from_code(+Code,-Value)
orientation_from_code(104,horizontal).

orientation_from_code(118,vertical).

% orientation_from_number(+Number,-Value)
orientation_from_number(1,vertical).

orientation_from_number(2,horizontal).

