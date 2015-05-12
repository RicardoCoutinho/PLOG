%
% Star Battle
% Each row, column and region bounded by bold borders must contain exactly
% the given number of stars.
% Stars may not touch each other, even diagonally.
%

:-use_module(library(clpfd)).
:-use_module(library(lists)).
:-use_module(library(between)).   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%                  DEMONSTRAÇÔES               %%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Resolução N=5, NStar=1
run1(Vars) :- 
    Areas = [A1,A2,A3,A4,A5],
    A1 = [(1,1),(2,1),(1,2),(1,3)],
    A2 = [(3,1),(4,1),(5,1),(2,2),(3,2),(5,2),(2,3),(3,3),(4,3),(5,3),(2,4),(4,4)],
    A3 = [(4,2)],
    A4 = [(1,4),(3,4),(1,5),(2,5),(3,5)],
    A5 = [(5,4),(4,5),(5,5)],
    
    N is 5, NStars is 1, 
    
    statistics(runtime,RT1), write(RT1),nl,
    
    solver(N,NStars,Areas,Vars),
    
    statistics(runtime,RT2), write(RT2),nl,nl,
    
    fd_statistics,nl,
    
    setup_map(N,Areas,Matrix),
    add_solutions(Vars,Matrix,Matrix2),
    
    write('Map of Matrix:'), nl,
    view(Matrix), nl,
    write('Map of Solutions:'), nl,
    view(Matrix2), nl     
    .

% Resolução N=4, NStar=1
run2(Vars) :- 
    Areas = [A1,A2,A3,A4],
    A1 = [(2,1)],
    A2 = [(4,2)],
    A3 = [(1,3)],
    A4 = [(1,1),(1,2),(1,4),(2,2),(2,3),(2,4),(3,1),(3,2),(3,3),(3,4),(4,1),(4,3),(4,4)],
    
    N is 4, NStars is 1,
    
    statistics(runtime,RT1), write(RT1),nl,
    
    solver(N,NStars,Areas,Vars),
    
    statistics(runtime,RT2), write(RT2),nl,nl,
    
    fd_statistics,nl,
    
    setup_map(N,Areas,Matrix),
    add_solutions(Vars,Matrix,Matrix2),
    
    write('Map of Matrix:'), nl,
    view(Matrix), nl,
    write('Map of Solutions:'), nl,
    view(Matrix2), nl     
    .

% Resolução N=9, NStar=2
run3(Vars) :-
    Areas=[A1, A2, A3, A4, A5, A6, A7, A8, A9],
        A1=[(1,1),(1,2),(2,2),(1,3),(2,3),(1,4),(2,4),(2,5)],
        A2=[(1,5),(1,6),(2,6),(1,7),(2,7),(1,8),(2,8),(1,9),(2,9),(3,9)],
        A3=[(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(3,2),(7,2)],
        A4=[(3,3),(3,4),(4,4),(3,5),(4,5),(3,6),(4,6),(4,7)],
        A5=[(8,2),(7,3),(8,3),(7,4),(8,4),(8,5)],
        A6=[(9,1),(9,2),(9,3),(9,4)],
        A7=[(9,5),(8,6),(9,6),(8,7),(9,7),(8,8),(9,8),(7,9),(8,9),(9,9)],
        A8=[(6,4),(6,5),(7,5),(6,6),(7,6),(6,7)],
        A9=[(4,2),(5,2),(6,2),(4,3),(5,3),(6,3),(5,4),(5,5),(5,6),(5,7),(3,7),(7,7),(3,8),(4,8),(5,8),(6,8),(7,8),(4,9),(5,9),(6,9)],
    
    N is 9, NStars is 2,
    
    statistics(runtime,RT1), write(RT1),nl,
    
    solver(N,NStars,Areas,Vars),
    
    statistics(runtime,RT2), write(RT2),nl,nl,
    
    fd_statistics,nl,
    
    setup_map(N,Areas,Matrix),
    add_solutions(Vars,Matrix,Matrix2),
    
    write('Map of Matrix:'), nl,
    view(Matrix), nl,
    write('Map of Solutions:'), nl,
    view(Matrix2), nl     
    .

% Resolução N=15, NStar=3
run4(Vars) :-
    Areas=[A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,A12,A13,A14,A15],

        A1=[(1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(1,2),(2,2),(7,2),(8,2),(8,3),(9,3),(10,3),(1,3),(1,4),(1,5),(1,6),(1,7),(2,7),(1,8),(2,8)],
        A2=[(9,1),(9,2),(10,2),(11,2),(11,3),(11,4),(12,4),(12,5),(13,5),(14,5),(14,6),(14,7),(15,7)],
        A3=[(10,1),(11,1),(12,1),(12,2),(12,3),(13,3),(13,4),(14,4),(15,4),(15,5),(15,6)],
        A4=[(13,1),(13,2),(14,1),(14,2),(14,3),(15,1),(15,2),(15,3)],
        A5=[(3,2),(4,2),(5,2),(6,2),(2,3),(3,3),(4,3),(2,4),(3,4),(2,5),(3,5),(2,6),(3,6),(3,7),(3,8),(3,9),(3,10),(4,10)],
        A6=[(5,3),(6,3),(7,3),(4,4),(5,4),(6,4),(4,5),(5,5),(6,5),(4,6),(5,6),(4,7),(4,8)],
        A7=[(7,4),(8,4),(7,5),(6,6),(7,6),(5,7),(6,7),(7,7),(5,8),(6,8),(7,8),(8,8)],
        A8=[(9,4),(10,4),(10,5),(11,5),(11,6),(11,7),(11,8),(11,9)],
        A9=[(8,5),(9,5),(8,6),(9,6),(10,6),(8,7),(9,7),(10,7),(12,7),(9,8),(10,8),(12,8),(9,9),(10,9),(12,9),(9,10),(10,10),(11,10),(12,10),(13,10),(14,10),(9,11),(10,11),(13,11),(14,11)],
        A10=[(12,6),(13,6),(13,7),(13,8),(14,8),(14,9),(15,8),(15,9),(15,10),(15,11),(15,12),(11,11),(12,11),(11,12),(12,12),(13,12),(14,12),(12,13),(12,14),(12,15),(11,15),(10,14),(10,15),(9,15),(8,15),(8,14),(8,13),(7,13),(6,13),(6,12)],
        A11=[(1,9),(2,9),(2,10),(2,11),(3,11),(4,11),(4,12),(5,12),(5,13),(5,14),(6,14),(7,14),(7,15)],
        A12=[(1,10),(1,11),(1,12),(2,12),(3,12),(3,13),(4,13),(4,14),(4,15),(5,15),(6,15)],
        A13=[(4,9),(5,9),(6,9),(7,9),(8,9),(5,10),(6,10),(7,10),(8,10),(5,11),(6,11),(7,11),(8,11),(7,12),(8,12),(9,12),(10,12),(9,13),(10,13),(11,13),(9,14),(11,14)],
        A14=[(1,13),(2,13),(1,14),(2,14),(3,14),(1,15),(2,15),(3,15)],
        A15=[(13,13),(13,14),(13,15),(14,13),(14,14),(14,15),(15,13),(15,14),(15,15)],
    
    N is 15, NStars is 3,
    
    statistics(runtime,RT1), write(RT1),nl,
    
    solver(N,NStars,Areas,Vars),
    
    statistics(runtime,RT2), write(RT2),nl,nl,
    
    fd_statistics,nl,
    
    setup_map(N,Areas,Matrix),
    add_solutions(Vars,Matrix,Matrix2),
    
    write('Map of Matrix:'), nl,
    view(Matrix), nl,
    write('Map of Solutions:'), nl,
    view(Matrix2), nl     
    .    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%                  PRINCIPAIS                  %%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%
% Resolve problemas
%
% solver(+SizeofMatrix,+NumberofStars,+Areas,-Variables)
solver(N,NStars,Areas,Variables) :- 
                       
    length(Areas,NAreas),
    TotalStars is NAreas * NStars, 
    length(Stars,TotalStars),
    
    def_domain(N,Stars),             % nl, write('Stars: '), write(Stars), nl,
    def_unique(N,NStars,Stars),      % nl, write('Stars: '), write(Stars), nl,
    def_proximity(Stars),            % nl, write('Stars: '), write(Stars), nl,
    def_stars(NStars,Areas,Stars,1), % nl, write('Stars: '), write(Stars), nl,
    
    flatten_tuples(Stars,Variables),
    labeling([],Variables).

%
% Gerador de problemas resolúveis
%
% (+SizeofMatrix,+NumberofStars,-Areas,Solution)
generator(N,NStars,Areas,Solution) :-            
    area_sizes(N,NStars,Sizes),
    
    length(Areas,N),
    maplist(length,Areas,Sizes),
    
    def_domain_areas(N,Areas),
    def_areas(N,Areas),
                                            
    flatten(Areas,TuplesList),
    flatten_tuples(TuplesList,List),
    
    labeling([],List),
    
    solver(N,NStars,Areas,Solution),
    
    setup_map(N,Areas,Matrix),
    add_solutions(Solution,Matrix,Matrix2),
    
    write('Map of Matrix:'), nl,
    view(Matrix), nl,
    write('Map of Solutions:'), nl,
    view(Matrix2), nl   
    .

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%                  SECUNDÁRIOS                 %%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
    
% area_sizes(+SizeofMatrix,+NumberofStars,-SizeofAreas)
area_sizes(N,NStars,Sizes) :-
    N>0,NStars>0, 
    length(Sizes,N), 
    NN is N*N,   
    Min is (2*NStars-1),
    Max is ((NN) - ((2*NStars-1)*N)),
    Max >= Min,
    def_domain_sizes(Min,Max,Sizes),
    sum(Sizes,#=,NN),
    labeling([],Sizes).    

% def_domain_sizes(+Min,+Max,+Sizes)
def_domain_sizes(Min,Max,[S|Ss]) :- S in Min..Max, def_domain_sizes(Min,Max,Ss).
def_domain_sizes(_,_,[]).

% def_areas(+Sizeofmatrix,+Areas)
def_areas(N,Areas) :- 
    flatten(Areas,TupleList),
    def_unique(N,N,TupleList)
    % def_area(Areas)
    .

% def_area(+Area)    
def_area([A|As]) :- continuous(A,A), def_area(As).  
def_area([]).    

% continuous(+Area,+Area)
continuous([Pos|L],Area) :- 
        has_path(Pos,Area,Bools),
        sum(Bools,#>,0),
        continuous(L,Area).
continuous([_],_).
continuous([],_).     

% has_path(+XY,+Area,-Bools)
has_path((X0,Y0),[(X1,Y1)|L],[Bool|Bools]) :-
    ( ( abs(X0-X1) #=1 #/\ abs(Y0-Y1) #=0 ) #\/ 
      ( abs(X0-X1) #=0 #/\ abs(Y0-Y1) #=1 ) ) #<=> Bool,    
    has_path((X0,Y0),L,Bools).
has_path((X,Y),[(X,Y)|L],[0|Bools]) :- has_path((X,Y),L,Bools).
has_path(_,[],[]).     


% def_domain(+SizeofMatrix,+TupleList)
def_domain(N,[(X,Y)|T]) :-
    N>0,
    X in 1..N,
    Y in 1..N,
    def_domain(N,T).
def_domain(_,[]).

% def_domain_areas(+Sizeofmatrix,+Areas)
def_domain_areas(N,[H|T]) :-
    def_domain(N,H),
    def_domain_areas(N,T).
def_domain_areas(_,[]).

% def_proximity(+Stars)
def_proximity([Star|Stars]) :-
    proximity_of(Star,Stars),
    def_proximity(Stars).
def_proximity([_]).

% def_unique(+SizeofMatrix,+NumberofStars,+Stars)
def_unique(N,NStars,Stars) :-
    split_tuples(Stars,StarsX,StarsY),
    cardinal(N,NStars,Cardinal),
    global_cardinality(StarsX,Cardinal),
    global_cardinality(StarsY,Cardinal).

% def_stars(+NumberofStars,+Areas,+Stars,+From)
def_stars(NStars,[Area|Areas],Stars,From) :-
        To is From+NStars,
        def_stars_per_area(NStars,Area,Stars,From,To),
        def_stars(NStars,Areas,Stars,To).
def_stars(_,[],_,_).

% proximity_of(+Star,+Stars)
proximity_of(Star1,[Star2|L]) :- 
        is_nextto(Star1,Star2,Bool), Bool #\= 1,
        proximity_of(Star1,L).
proximity_of(_,[]).

% is_nextto(+Tuple1,+Tuple2,-Bool)
is_nextto((X,Y),(X,Y),0).
is_nextto((X1,Y1),(X2,Y2),Bool) :- 
        (( abs(X1-X2) #= 1 #/\ abs(Y1-Y2) #= 1 )  #\/ 
         ( abs(X1-X2) #= 1 #/\ abs(Y1-Y2) #= 0 )  #\/
         ( abs(X1-X2) #= 0 #/\ abs(Y1-Y2) #= 1 )) #<=> Bool.

% def_area(+NumberofStars,+Area,+Stars,+From,+To)
def_stars_per_area(NStars,Area,Stars,From,To) :-        
        From < To,
        nth1(From,Stars,Star),
        star_in_area(Star,Area,Bools), 
        sum(Bools,#=,1),
        From1 is From+1,
        def_stars_per_area(NStars,Area,Stars,From1,To).
def_stars_per_area(_,_,_,From,To) :- From >= To.

% star_in_area(+XY1,Area,-BoolList)
star_in_area((X,Y),[(X1,Y1)|L],[Bool|Bools]) :- 
        (X#=X1 #/\ Y#=Y1) #<=> Bool, 
        star_in_area((X,Y),L,Bools).
star_in_area(_,[],[]).

% cardinal(+SizeofMatrix,+NumberofStars,-CardinalList)
cardinal(N,NStars,[N-NStars|T]) :- N>0, N1 is N-1, cardinal(N1,NStars,T).
cardinal(N,_,[]) :- N=<0.   

% add_solutions(+Solutions,+Matrix,-MatrixOut)
add_solutions([X,Y|L],M,M3) :- put('*',(X,Y),M,M2), add_solutions(L,M2,M3).
add_solutions([],M,M).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%                  AUXILIARES                  %%%%%%%%%%
%%%%%%%%%%                                              %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% flatten(+NestedList,-List)
flatten([], []) :- !.
flatten([L|Ls], FlatL) :-
    !,
    flatten(L, NewL),
    flatten(Ls, NewLs),
    append(NewL, NewLs, FlatL).
flatten(L, [L]).

% split_tuple(+TupleList,-XList,-YList)         
split_tuples([(X,Y)|L],[X|Xs],[Y|Ys]) :- split_tuples(L,Xs,Ys).
split_tuples([],[],[]).

% flatten_tuples(+TupleList,-List)
flatten_tuples([(A,B)|L],[A,B|Z]) :-flatten_tuples(L,Z).
flatten_tuples([],[]).


/*
   A1 :: 1's
   A2 :: 2's
   A3 :: 3's
   ...
   STAR :: *
*/
% setup_map(+Sizeofmatrix,+Areas,-MatrixOut)
setup_map(N,Areas,M2) :-
    n_matrix(N,M),
    map_areas(1,Areas,M,M2).

% n_matrix(+N, -Matrix)
n_matrix(N, Matrix) :- findall(Row, (between(1,N,_),length(Row, N)), Matrix).        

% map_areas(+Sizeofmatrix,+Areas,+Matrix,-MatrixOut)
map_areas(N,[A|As],M,M3) :- 
    map_area(N,A,M,M2),
    N1 is N+1, map_areas(N1,As,M2,M3).
map_areas(_,[],M,M).

% map_area(+Content,+TupleList,+Matrix,-MatrixOut)
map_area(P,[Pos|L],M,M3) :- 
    put(P,Pos,M,M2),
    map_area(P,L,M2,M3).
map_area(_,[],M,M).

% put(+Piece,(+X,+Y),+Matrix,-Matrix2)
put(P,(X,Y),M,M2) :-
    append(Ma,[L|Mz],M),   length(Ma,Y1), Y1 is Y-1,
    append(La,[_|Lz],L),   length(La,X1), X1 is X-1,
    append(Ma,[L2|Mz],M2),
    append(La,[P|Lz],L2).

% view(Matrix)
view([R|Rs]) :-
    write(R), nl,
    view(Rs).
view([]).    

