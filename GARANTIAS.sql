
SELECT T0."customer", T0."custmrName", T0."Telephone", T0."itemCode", T0."itemName", 
T1."ItmsGrpNam", T0."DocNum", T2."Name", T0."callID",
CASE 
	WHEN T0."priority" = 'H' THEN 'ALTA'
	WHEN T0."priority" = 'M' THEN 'MEDIA'
	WHEN T0."priority" = 'L' THEN 'BAJA' 
ELSE T0."priority"
END "PRIORIDAD",
T0."createDate", 
T0."createTime", T0."closeDate", T0."closeTime", T3."Name", T4."Name",
T0."U_Tecnico", T0."BPShipAddr", 
CASE
	WHEN T0."U_Aplica" = 1 THEN 'SI'
	WHEN T0."U_Aplica" = 2 THEN 'NO'
	WHEN T0."U_Aplica" = 3 THEN 'EXCEPCION'
ELSE T0."U_Aplica"
END "APLICA_GARANTIA"
, T0."U_Vendedor", 
CASE 
	WHEN T0."U_Sucursal" = 1 THEN 'JP'
	WHEN T0."U_Sucursal" = 2 THEN 'ML'
	WHEN T0."U_Sucursal" = 3 THEN 'SM'
ELSE T0."U_Sucursal"
END "SUCURSAL", T5."U_NAME", 
T0."resolution", T0."descrption" 
FROM OSCL T0  
INNER JOIN OITB T1 ON T0."itemGroup" = T1."ItmsGrpCod" 
INNER JOIN OSCS T2 ON T0."status" = T2."statusID" 
INNER JOIN OSCO T3 ON T0."origin" = T3."originID" 
INNER JOIN OSCP T4 ON T0."problemTyp" = T4."prblmTypID" 
INNER JOIN OUSR T5 ON T0."assignee" = T5."USERID"
WHERE T2."Name"!='Cancelado'