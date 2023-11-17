:- module(alfabeta, [alfabeta/5]).

% alfabeta(+Pos,+Alfa,+Beta,-MigliorPosSucc,-Val) =====================
% Minimax con potatura alfa-beta
alfabeta(Pos,Alfa,Beta,MigliorPosSucc,Val) :-% Pos ha MigliorPosSucc se
  bagof(PosSucc, mossa(Pos, PosSucc), ListaPosSucc),         % ha mosse
  !,                                                  % e la migliore è
  migliore(ListaPosSucc,Alfa,Beta,MigliorPosSucc,Val)  % MigliorPosSucc
  ;                                                        % altrimenti
  utilita(Pos,Val).  % Pos è terminale e restituisce l'utilità come Val

% migliore(+Lista,+Alfa,+Beta,-MigliorPosSucc,-Val) ===================
% restituisce MigliorPosSucc da una Lista di possibili successori
% ed il suo Val rimanendo sempre dentro i limiti Alfa e Beta
migliore([Pos|AltrePos],Alfa,Beta,MigliorPosSucc,MigliorVal) :-
  alfabeta(Pos,Alfa,Beta, _,Val),       % determina Val associato a Pos
  potato(AltrePos,Alfa,Beta,Pos,Val,MigliorPosSucc,MigliorVal).

% potato(+Lista,+Alfa,+Beta,Pos,Val,PosGiaBuona,ValGiaBuono) ==========
potato([],_,_,Pos,Val,Pos,Val) :- !.      % non ci sono altre posizioni
potato(_,Alfa,Beta,Pos,Val,Pos,Val) :-
  tocca_a_MIN(Pos), Val > Beta, !                           % beta test: se in pos tocca a min vede che il val > beta
  ;
  tocca_a_MAX(Pos), Val < Alfa, !.                          % alfa test: se tocca a max vede che il val < alfa
potato(ListaPos,Alfa,Beta,Pos,Val,PosGiaBuona,ValGiaBuono)  :- % si va in profondità e aggiorna alpha e beta
  aggiornaAlfaBeta(Alfa,Beta,Pos,Val,NAlfa,NBeta),     % stringe limiti
  migliore(ListaPos,NAlfa,NBeta,Pos1,Val1),
  miglioreDi(Pos,Val,Pos1,Val1,PosGiaBuona,ValGiaBuono).

% aggiornaAlfaBeta(Alfa,Beta,Pos,Val,NewAlpha,NewBeta) ========================
% man mano che il gioco procede, alpha e beta si avvicinano l'un l'altro
% alpha da -inf cresce, beta da +inf diminuisce
aggiornaAlfaBeta(Alfa,Beta,Pos,Val,Val,Beta)  :-
  tocca_a_MIN(Pos), Val > Alfa, !.          % gioca MIN si aumenta Alfa
aggiornaAlfaBeta(Alfa,Beta,Pos,Val,Alfa,Val)  :-
  tocca_a_MAX(Pos), Val < Beta, !.       % gioca MAX si diminuisce Beta
aggiornaAlfaBeta(Alfa,Beta,_,_,Alfa,Beta).       % nessun aggiornamento: sono in un nodo in cui devo andare avanti in profondità

% miglioreDi(+Pos0, +Val0, +Pos1, +Val1, -Pos, -Val) ==================
% restituisce la migliore coppia Pos Val fra le due considerate
miglioreDi(Pos,Val,_,Val1,Pos,Val) :-           % Pos0 è meglio di Pos1
    tocca_a_MIN(Pos),                   % se in Pos0 deve muovere MIN e
    Val > Val1, !                      % MAX sceglie il valore maggiore
    ;                                                          % oppure
    tocca_a_MAX(Pos),                      % se in Pos0 deve muovere  e
    Val < Val1, !.                       % MIN sceglie il valore minore
miglioreDi(_,_,Pos,Val,Pos,Val).     % altrimenti Pos1 è meglio di Pos0
