# Libreria **Prolog** per **URI parsing**

## Interfaccia della libreria
La libreria è composta da un'interfaccia (***"uri-parse.pl"***) che contiene la definizione dei
2 predicati richiesti (<code>uri_parse</code> e <code>uri_display</code>).

## Moduli interni
Gli altri file presenti sono moduli interni per la costruzione degli automi a stati finiti richiesti per
il riconoscimento dell'uri; in particolare, essi vengono caricati automaticamente dopo il caricamento
dell'interfaccia e ogni modulo prende il nome della componente che riconosce. Inoltre questi moduli si 
richiamano a vicenda seguendo la struttura della grammatica richiesta: si garantisce così un'elevata 
modularità, che favorisce eventuali modifiche alle grammatiche definite.

Alcuni moduli non sono strettamente correlati al riconoscimento di un campo della struttura uri:
- ***"uri-util.pl"*** è un modulo di appoggio per l'interfaccia ***"uri-parse.pl"***;
- ***"definitions.pl"*** contiene la definizione dei termini base della grammatica;
- ***"optional.pl"*** viene utilizzato per la gestione della parte opzionale della grammatica <code>URI1</code>
(*['/' [path] ['?' query] ['#' fragment']]*);
- ***"grammar1.pl"*** viene utilizzato per il riconoscimento di <code>URI1</code> con <code>authorithy</code> non opzionale
(*scheme ':' authorithy ['/' [path] ['?' query] ['#' fragment']]*)
- ***"grammar2.pl"*** viene utilizzato per il riconoscimento di <code>URI1</code> senza <code>authorithy</code> 
(*scheme ':' ['/' [path] ['?' query] ['#' fragment']]*)
- ***"display.pl"*** contiene predicati per la stampa in formato testuale di una struttura uri e
per rendere invertibile il predicato ***'uri-parse'*** (a scopo di testing).

## Note

- Nella definizione dei termini base, non viene eseguito nessun controllo sul termine 'caratteri'
(per esempio, *fragment ::= <caratteri>+* riconosce qualsiasi carattere che viene inserito).

- Seguendo le indicazioni date, la stringa <code>"zos:"</code> non viene accettata in quanto lo schema zos richiede un path
obbligatorio; inoltre, se non viene specificata esplicitamente la porta, viene inserita di default 80 in ogni schema,
anche se tale schema non comprende la porta nella sua definizione.

