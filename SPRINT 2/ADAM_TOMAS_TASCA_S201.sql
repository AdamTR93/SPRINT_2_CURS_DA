
#NIVELL 1
#EXERCICI 1
#Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT *
FROM transaction
WHERE company_id IN (SELECT id FROM company WHERE country = 'Germany');


        

#EXERCICI 2
#Màrqueting està preparant alguns informes de tancaments de gestió, et demanen que els passis un llistat
#de les empreses que han realitzat transaccions per una suma superior a la mitjana de totes les transaccions.

SELECT company_name
FROM company
WHERE id IN (SELECT company_id
				FROM transaction
				WHERE amount > (SELECT AVG(amount) FROM transaction));
                


#EXERCICI 3
#El departament de comptabilitat va perdre la informació de les transaccions realitzades per una empresa,
#però no recorden el seu nom, només recorden que el seu nom iniciava amb la lletra c. Com els pots ajudar?
#Comenta-ho acompanyant-ho de la informació de les transaccions.


SELECT *, (SELECT company_name FROM company WHERE company_name LIKE 'C%' AND company.id=transaction.company_id) as Company
FROM transaction
WHERE company_id IN (SELECT id FROM company WHERE company_name LIKE 'C%')
AND declined=0;


#EXERCICI 4
#Van eliminar del sistema les empreses que no tenen transaccions registrades, lliura el llistat d'aquestes empreses.

SELECT company_name
FROM company
WHERE id NOT IN (SELECT DISTINCT company_id FROM transaction);


#NIVELL 2
#EXERCICI 1
#En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries
#per a fer competència a la companyia senar institute. Per a això, et demanen la llista de totes les transaccions
#realitzades per empreses que estan situades en el mateix país que aquesta companyia.

SELECT *, (SELECT country FROM company WHERE company.id=transaction.company_id) as Country
FROM transaction
WHERE company_id IN(SELECT id
						FROM company
						WHERE country = 'United States');
                        
#EXERCICI 2
#El departament de comptabilitat necessita que trobis l'empresa
#que ha realitzat la transacció de major suma en la base de dades.

SELECT company_name
FROM company
WHERE id = (SELECT company_id
				FROM transaction
				GROUP BY company_id
				ORDER BY SUM(amount) DESC
				LIMIT 1);

SELECT company_name, id
FROM company
WHERE id IN (SELECT company_id
					FROM (SELECT company_id
							FROM transaction
                            WHERE declined = 0
							GROUP BY company_id
							ORDER BY SUM(amount) DESC
							LIMIT 1) as IdCompany);



#NIVELL 3
#EXERCICI 1
#S'estan establint els objectius de l'empresa per al següent trimestre, per la qual cosa necessiten una base sòlida
#per a avaluar el rendiment i mesurar l'èxit en els diferents mercats.
#Per a això, necessiten el llistat dels països la mitjana de transaccions dels quals sigui superior a la mitjana general.


SELECT DISTINCT country
FROM company
WHERE id IN (SELECT company_id
				FROM transaction
                GROUP BY company_id
				HAVING AVG(amount) > (SELECT AVG(amount) FROM transaction))
ORDER BY country;

#Francia y España, son los únicos países que la media de sus transacciones no es superior a la media de las transacciones en general.

#EXERCICI 2
#Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi,
#per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses,
#però el departament de recursos humans és exigent i vol un llistat de les empreses
#on especifiquis si tenen més de 4 transaccions o menys.

SELECT company_name, (SELECT COUNT(amount) FROM transaction WHERE company_id = company.id) as NumTrans
FROM company
WHERE id IN (SELECT company_id
				FROM (SELECT company_id, COUNT(amount)
							FROM transaction
							GROUP BY company_id) AS Trans)
ORDER BY NumTrans DESC;



