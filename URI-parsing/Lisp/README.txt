Membri progetto:
	
	Volpato Mattia 866316
	Colombo Marco  866431


La libreria è composta da un'interfaccia ("uri-parse.lisp") che contiene la definizione delle 
2 funzioni principali richieste ('uri-parse' e 'uri-display'); la struttura uri è realizzata mediante
la macro defstruct, che genera automaticamente le funzioni di accesso ai vari campi della struttura.

Gli altri file presenti sono moduli interni per la costruzione degli automi a stati finiti richiesti per
il riconoscimento dell'uri; in particolare, essi vengono caricati automaticamente dopo il caricamento
dell'interfaccia e ogni modulo prende il nome della componente che riconosce. Inoltre questi moduli si 
richiamano a vicenda seguendo la struttura della grammatica richiesta: si garantisce così un'elevata 
modularità, che favorisce eventuali modifiche alle grammatiche definite.

Alcuni moduli non sono strettamente correlati al riconoscimento di un campo della struttura uri:
	- "uri-struct.lisp" è un modulo di appoggio per l'interfaccia uri-parse;
	- "definitions.lisp" contiene la definizione dei termini base della grammatica;
	- "optional.lisp" viene utilizzato per la gestione della parte opzionale della grammatica URI1
	   (['/' [path] ['?' query] ['#' fragment']]);
	- "grammar1.lisp" viene utilizzato per il riconoscimento di URI1 con authorithy non opzionale
	  (scheme ':' authorithy ['/' [path] ['?' query] ['#' fragment']]);
	- "grammar2.lisp" viene utilizzato per il riconoscimento di URI1 senza authorithy 
	  (scheme ':' ['/' [path] ['?' query] ['#' fragment']]).

Nella definizione dei termini base, non viene eseguito nessun controllo sul termine 'caratteri'
(per esempio, fragment ::= <caratteri>+ riconosce qualsiasi carattere che viene inserito).

Seguendo le indicazioni date, la stringa "zos:" non viene accettata in quanto lo schema zos richiede un path
obbligatorio; inoltre, se non viene specificata esplicitamente la porta, viene inserita di default 80 in ogni schema,
anche se tale schema non comprende la porta nella sua definizione.

