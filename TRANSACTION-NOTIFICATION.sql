CREATE PROCEDURE SBO_SP_TransactionNotification
(
	in object_type nvarchar(30), 				-- SBO Object Type
	in transaction_type nchar(1),			-- [A]dd, [U]pdate, [D]elete, [C]ancel, C[L]ose
	in num_of_cols_in_key int,
	in list_of_key_cols_tab_del nvarchar(255),
	in list_of_cols_val_tab_del nvarchar(255)
)
LANGUAGE SQLSCRIPT
AS
-- Return values
error  int;				-- Result (0 for no error)
flag nvarchar(200);	
error_message nvarchar (200); 		-- Error string to be displayed
begin

error := 0;
error_message := N'Ok';

--------------------------------------------------------------------------------------------------------------------------------
--	ADD	YOUR	CODE	HERE

--No puede facturar de sucursales diferentes
if object_type = '17' and  transaction_type in ('A','U')
   then 
      if ( SELECT  COUNT(W0."WHSCODE")  FROM(
SELECT DISTINCT 
 T0."DocEntry" ,
 SUBSTRING(T1."WhsCode",0,2) WHSCODE
FROM ORDR T0 INNER JOIN RDR1 T1 ON T0."DocEntry" = T1."DocEntry" WHERE T0."DocEntry"= list_of_cols_val_tab_del 
)W0 ) > 1
      then
      error = 1001;
      error_message := N'No puede facturar de sucursales diferentes';
   end if;
end if;

--No puede facturar de sucursales diferentes
if object_type = '17' and  transaction_type in ('A','U')
   then 
      if ( SELECT  COUNT( T0."DocEntry") 
FROM ORDR T0 INNER JOIN OCRD T1 ON T0."CardCode" = T1."CardCode"  WHERE T1."GroupNum" in (-1,1) AND  T0."GroupNum" > 2 AND T0."DocEntry"= list_of_cols_val_tab_del 
 ) > 1
      then
      error = 10011;
      error_message := N'No puede facturar de sucursales diferentes';
   end if;
end if;


--No puede facturar productos sin  stock 
if object_type = '17' and  transaction_type in ('A','U')
   then 
      if  (SELECT  COUNT(T1."ItemCode") 
FROM RDR1 T1 INNER JOIN OITW T2 ON T1."ItemCode" = T2."ItemCode" AND T1."WhsCode" = T2."WhsCode" 
WHERE T2."OnHand" = 0 and SUBSTRING(T1."ItemCode",0,4)!= 'SERV' AND T1."DocEntry"= list_of_cols_val_tab_del 
 ) >= 1
      then
      error = 1002;
      error_message := N'No puede facturar productos sin  stock ';
   end if;
end if;

--Debe de seleccionar el Forma de envío
IF object_type = '17' AND transaction_type IN ('A','U')  THEN 
  
flag = '';

	SELECT Count(*) into flag 
	FROM ORDR T0 
	WHERE T0."TrnspCode" = -1 AND 
	T0."DocEntry" = CAST(list_of_cols_val_tab_del AS NVARCHAR(15)) ;
 		IF flag >= 1 THEN 
		 error='1111';
		 error_message = '***** Debe seleccionar Forma de Envío *****';
		END IF;	
END IF;

--debe de seleccionar el tipo de Oferta
if object_type = '23' and  transaction_type in ('A','U')
   then 
      if  (SELECT  COUNT(T0."CardCode") 
FROM OQUT T0 
WHERE T0."U_TIPO" IS NULL AND T0."DocEntry"= list_of_cols_val_tab_del 
 ) >= 1
      then
      error = 1003;
      error_message := N'Seleccione una opcion en Tipo';
   end if;
end if;


--No puede facturar productos sin  stock 
if object_type = '17' and  transaction_type in ('A','U')
   then 
      if  (SELECT  COUNT(T1."ItemCode") 
FROM RDR1 T1 
INNER JOIN OITM T2 ON T1."ItemCode" = T2."ItemCode"
WHERE T1."Price" = 0 AND T1."DocEntry"= list_of_cols_val_tab_del AND T2."TreeType" = 'N'
 ) >= 1
      then
      error = 1004;
      error_message := N'No puede crear este documento sin precio';
   end if;
end if;


--No puede facturar productos sin  stock 
if object_type = '13' and  transaction_type in ('A','U')
   then 
      if  (SELECT  max(T1."LineNum")
FROM INV1 T1 
WHERE   T1."DocEntry"= list_of_cols_val_tab_del 
 ) > 19
      then
      error = 1005;
      error_message := N'No puede pasar de 19 lineas';
   end if;
end if;

--No puede facturar de sucursales diferentes
if object_type = '17' and  transaction_type in ('A','U')
   then 
      if ( SELECT  COUNT( T0."DocEntry") 
FROM ORDR T0 INNER JOIN OCRD T1 ON T0."CardCode" = T1."CardCode"  WHERE T1."GroupNum" = 1  AND  T0."GroupNum" NOT IN ('1','2') AND T0."DocEntry"= list_of_cols_val_tab_del 
 ) > 0
      then
      error = 1006;
      error_message := N'No puede cambiar la condicion a credito de un cliente de contado';
   end if;
end if;



--No puede facturar de sucursales diferentes
if object_type = '17' and  transaction_type in ('A','U')
   then 
      if ( SELECT  COUNT(T0."DocNum") FROM ORDR T0 INNER JOIN RDR1 T1 ON T0."DocEntry" = T1."DocEntry" 
      WHERE T1."DiscPrcnt" > 0 AND  T0."UserSign" IN ('23','24','25','26','27','30','31','32','33','34','35','36','21','57','58') AND  T0."DocEntry"= list_of_cols_val_tab_del 
 ) >= 1
      then
      error = 1007;
      error_message := N'Este documento tiene descuento, para generarlo solicitar al encargaro de la tienda (Miguel, Walter o Christian) para que lo genere como pedido';
   end if;
end if;

--No puede facturar de sucursales diferentes
if object_type = '17' and  transaction_type in ('A','U')
   then 
      if ( SELECT  COUNT(T0."DocNum") FROM ORDR T0 INNER JOIN RDR1 T1 ON T0."DocEntry" = T1."DocEntry"
      LEFT JOIN "OCRD" T2 ON T0."CardCode" = T2."CardCode" 
      WHERE T0."CardName" != T2."CardName" AND T0."CardCode" NOT IN ('CFJP','CFMR','CFSM') AND  T0."DocEntry"= list_of_cols_val_tab_del 
 ) >= 1
      then
      error = 1008;
      error_message := N'El nombre del socio de negocio no corresponde al asignado en el dato maestro.';
   end if;
end if;


---VALIDA SI LA CEDULA YA ESTA REGISTRADA


if object_type = '2' and transaction_type in ('A','U') then

flag = '';

select  a."LicTradNum" into flag from OCRD a where a."CardCode" = list_of_cols_val_tab_del;

	if (select count (b."LicTradNum") from ocrd b where b."LicTradNum" IS NOT NULL and b."LicTradNum" = flag) >1 then

     error = 1;
     error_message = N'Numero de Cedula ya existe !!!';
    
     
	end if;
end if;

if object_type = '2' and transaction_type in ('A','U') then

flag = '';

select  a."AddID" into flag from OCRD a where a."CardCode" = list_of_cols_val_tab_del;

	if (select count (b."AddID") from ocrd b where b."AddID" IS NOT NULL and b."AddID" = flag) >1 then

     error = 1;
     error_message = N'Numero de Cedula ya existe !!!';
    
     
	end if;
end if;

/*if object_type = '2' and transaction_type in ('A','U') then

flag = '';

select  a."U_DUI" into flag from OCRD a where a."CardCode" = list_of_cols_val_tab_del;

	if (select count (b."U_DUI") from ocrd b where b."U_DUI" IS NOT NULL and b."U_DUI" = flag) >1 then

     error = 1;
     error_message = N'Numero de Cedula ya existe !!!';
    
     
	end if;                                                                                                          
end if;

if object_type = '2' and transaction_type in ('A','U') then

flag = '';

select  a."VatIdUnCmp" into flag from OCRD a where a."CardCode" = list_of_cols_val_tab_del;

	if (select count (b."VatIdUnCmp") from ocrd b where b."VatIdUnCmp" IS NOT NULL and b."VatIdUnCmp" = flag) >1 then

     error = 1;
     error_message = N'Numero de Cedula ya existe !!!';
    
     
	end if;
end if;

*/
 

--Los socios de los documentos no es igual al socio de datos maestros de negocio
if object_type = '13' and  transaction_type in ('A','U')
   then 
      if ( SELECT  COUNT(T0."DocNum") FROM OINV T0 INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
      LEFT JOIN "OCRD" T2 ON T0."CardCode" = T2."CardCode" 
      WHERE T0."CardName" != T2."CardName" AND T0."CardCode" NOT IN ('CFJP','CFMR','CFSM') AND  T0."DocEntry"= list_of_cols_val_tab_del 
 ) >= 1
      then
      error = 1009;
      error_message := N'El nombre del socio de negocio no corresponde al asignado en el dato maestro.';
   end if;
end if;


if object_type = '24' and  transaction_type in ('A','U')
   then 
      if ( SELECT  COUNT(T0."CashAcct") FROM ORCT T0 
      WHERE (T0."CashAcct" = '1-1-02-010300' or T0."CheckAcct" = '1-1-02-010300' or T0."TrsfrAcct" = '1-1-02-010300')  AND  T0."DocEntry"= list_of_cols_val_tab_del 
 ) >= 1
      then
      error = 10010;
      error_message := N'No se puede generar el pago sobre la cuenta 1-1-02-010300 - Banco Agricola - 5110010654 .';

   end if;
end if;


if object_type = '4' and  transaction_type in ('A')
   then 
      if  (SELECT  COUNT(T0."ItemCode")
FROM OITM T0
WHERE   T0."UserSign" NOT in ('46','47','17') and  T0."ItemCode"= list_of_cols_val_tab_del 
 ) > 0
      then
      error = 1011;
      error_message := N'Los Arituclos solo se pueden crear desde Miami, comunicarse con Viviana Morales.';
   end if;
end if;


if object_type = '17' and  transaction_type in ('A')
   then 
      if  (SELECT  COUNT(T0."DocEntry")
FROM ORDR T0
INNER JOIN RDR1 T1 ON T0."DocEntry" = T1."DocEntry"
INNER JOIN OUSR T2 ON T0."UserSign" = T2."USERID"
WHERE  T2."DfltsGroup" != '0009' AND T1."ItemCode" in ('SERVICIO','SERVICIO 2','SERVICIO 3', 'SERVICIO 4') AND  T0."DocEntry"= list_of_cols_val_tab_del 
 ) > 0
      then
      error = 1012;
      error_message := N'No puede facturar articulos de servicios';
   end if;
end if;


/*if object_type = '23' and  transaction_type in ('A','U')
   then 
      if  (SELECT  COUNT(T0."TrnspCode")
FROM OQUT T0
WHERE  T0."TrnspCode" ='-1' AND  T0."DocEntry"= list_of_cols_val_tab_del 
 ) > 0
      then
      error = 1013;
      error_message := N'Debe de definir una forma de envio';
   end if;
end if;*/


if object_type = '22' and  transaction_type in ('A','U')
   then 
      if ( SELECT  COUNT( T0."DocEntry") 
FROM OPOR T0   WHERE T0."U_OrdenMiami" IS NOT NULL AND T0."U_Provee_LLC" IS NULL AND T0."DocEntry"= list_of_cols_val_tab_del 
 ) > 0
      then
      error = 1008;
      error_message := N'Debe de selecionar un proveedor LLC';
   end if;
end if;

if object_type = '22' and  transaction_type in ('A','U')
   then 
      if ( SELECT  COUNT( T0."DocEntry") 
FROM OPOR T0   WHERE LENGTH(T0."U_OrdenMiami") > 4   AND T0."DocEntry"= list_of_cols_val_tab_del 
 ) > 0
      then
      error = 1008;
      error_message := N'El Consecutivo no es correcto en LLC';
   end if;
end if;


-- Campo DUI

IF object_type = '2' AND transaction_type IN ('A','U')  THEN 
  
flag = '';

	SELECT Count(*) into flag 
	FROM OCRD T0 
	WHERE T0."U_DUI" IS NULL  AND T0."CardType" = 'C' AND 
	T0."CardCode" = CAST(list_of_cols_val_tab_del AS NVARCHAR(15)) ;
 		IF flag>= '1' THEN 
		 error='1111';
		 error_message = '***** Debe de llenar el campo DUI en el Dato Maetro del Socio de Negicios  *****';
		END IF;	
END IF;

---BLOQUEO DE DOCUMENTOS POR ALMACEN------

--ORDEN DE VENTA
IF object_type in ('17') AND transaction_type IN ('A', 'U')  THEN 
flag = '';
	SELECT count(T1."UserSign") into flag 
	FROM ORDR T1 INNER JOIN RDR1 T2 on T1."DocEntry" = T2."DocEntry" 
	WHERE T1."UserSign" IN (23,24,25,26,27,30,31,32,33,34,35,36,60,61,41) 
	AND T2."WhsCode" in ('01','C05','D04-M','D04-JP','PR03-JP','PR03-M','REP06','SAFE','SIKA','TRANS','TRANSAP','SBFA-JP','SBFA-M')
	AND T1."DocEntry" = CAST(list_of_cols_val_tab_del AS NVARCHAR(15));
 		IF flag >= '1' THEN 
		 error='1010';
		 error_message = '***** ALMACEN NO PERMITIDO PARA CREAR ORDEN DE VENTA, CORREGIR EL AMACEN *****';
		END IF;	
END IF;

--OFERTA DE VENTA
IF object_type in ('23') AND transaction_type IN ('A', 'U')  THEN 
flag = '';
	SELECT count(T1."UserSign") into flag 
	FROM OQUT T1 INNER JOIN QUT1 T2 on T1."DocEntry" = T2."DocEntry" 
	WHERE T1."UserSign" IN (23,24,25,26,27,30,31,32,33,34,35,36,60,61,41) 
	AND T2."WhsCode" in ('01','C05','D04-M','D04-JP','PR03-JP','PR03-M','REP06','SAFE','SIKA','TRANS','TRANSAP','SBFA-JP','SBFA-M')
	AND T1."DocEntry" = CAST(list_of_cols_val_tab_del AS NVARCHAR(15));
 		IF flag >= '1' THEN 
		 error='1010';
		 error_message = '***** ALMACEN NO PERMITIDO PARA CREAR OFERTA DE VENTA, CORREGIR EL ALMACEN *****';
		END IF;	
END IF;

--BLOQUEO DE FACTURAS POR USUARIO Y ALMACEN.

IF object_type in ('13') AND transaction_type IN ('A', 'U')  THEN 
flag = '';
	SELECT count(T1."UserSign") into flag 
	FROM OINV T1 INNER JOIN INV1 T2 on T1."DocEntry" = T2."DocEntry" 
	WHERE T1."UserSign" IN (29) 
	AND T2."WhsCode" in ('01','C05','D04-JP','D04-M','PR03-JP','PR03-M','REP06','SAFE','SIKA','TRANS','TRANSAP','SBFA-JP','SBFA-M','BME1','BME2''SM1','SM2')
	AND T1."DocEntry" = CAST(list_of_cols_val_tab_del AS NVARCHAR(15));
 		IF flag >= '1' THEN 
		 error='1010';
		 error_message = '***** ALMACEN NO PERMITIDO PARA CREAR FACTURAS PARA ESTE USUARIO, CORREGIR EL ALMACEN *****';
		END IF;	
END IF;

IF object_type in ('13') AND transaction_type IN ('A', 'U')  THEN 
flag = '';
	SELECT count(T1."UserSign") into flag 
	FROM OINV T1 INNER JOIN INV1 T2 on T1."DocEntry" = T2."DocEntry" 
	WHERE T1."UserSign" IN (38) 
	AND T2."WhsCode" in ('01','C05','D04-JP','D04-M','PR03-JP','PR03-M','REP06','SAFE','SIKA','TRANS','TRANSAP','SBFA-JP','SBFA-M','BJP1','BJP2','SM1','SM2')
	AND T1."DocEntry" = CAST(list_of_cols_val_tab_del AS NVARCHAR(15));
 		IF flag >= '1' THEN 
		 error='1010';
		 error_message = '***** ALMACEN NO PERMITIDO PARA CREAR FACTURAS PARA ESTE USUARIO, CORREGIR EL ALMACEN *****';
		END IF;	
END IF;

IF object_type in ('13') AND transaction_type IN ('A', 'U')  THEN 
flag = '';
	SELECT count(T1."UserSign") into flag 
	FROM OINV T1 INNER JOIN INV1 T2 on T1."DocEntry" = T2."DocEntry" 
	WHERE T1."UserSign" IN (60) 
	AND T2."WhsCode" in ('01','C05','D04-JP','D04-M','PR03-JP','PR03-M','REP06','SAFE','SIKA','TRANS','TRANSAP','SBFA-JP','SBFA-M','BJP1','BJP2','BME1','BME2')
	AND T1."DocEntry" = CAST(list_of_cols_val_tab_del AS NVARCHAR(15));
 		IF flag >= '1' THEN 
		 error='1010';
		 error_message = '***** ALMACEN NO PERMITIDO PARA CREAR FACTURAS PARA ESTE USUARIO, CORREGIR EL ALMACEN *****';
		END IF;	
END IF;


------------------BLOQUEO RETENCIONES----------------------

if object_type = '13' and  transaction_type in ('A')
   then 
      if  (SELECT  Count (*) 
FROM OINV T0
INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
INNER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
WHERE  T2."WTLiable" = 'Y'  AND T1."WtLiable" <> 'Y' AND (T0."DocTotal" - T0."VatSum" + T0."WTSum")  > 100 AND T0."DocEntry" =  CAST(list_of_cols_val_tab_del AS NVARCHAR(15))  
) >= 1
      then
      error = 1012;
      error_message := N'*****FACTURA DE MAS DE $100 Y EXISTE UNA LINEA SIN RETENCION*****';
   end if;
end if;

if object_type = '13' and  transaction_type in ('A')
   then 
      if  (SELECT  Count (*) 
FROM OINV T0
INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry"
INNER JOIN OCRD T2 ON T0."CardCode" = T2."CardCode"
WHERE  T2."WTLiable" = 'Y'  AND T1."WtLiable" <> 'N' AND  (T0."DocTotal" - T0."VatSum" + T0."WTSum") < 100 AND T0."DocEntry" =   CAST(list_of_cols_val_tab_del AS NVARCHAR(15))  
) >= 1
      then
      error = 1013;
      error_message := N'*****FACTURA  DE MENOS DE $100 Y EXISTE UNA LINEA CON RETENCION*****';
   end if;
end if;

----Bloquea lineas duplicadas en el documento

IF object_type = '1250000001' and transaction_type in ('A','U')and 
(Select Distinct 'True'  FROM WTQ1 T1 WHERE cast (T1."DocEntry" as nvarchar) = list_of_cols_val_tab_del
Group by T1."ItemCode" Having count (T1."LineNum") > 1) = 'True'
then
error='101';
		 error_message = ' ****No puede crear documento con codigos de articulos Repetido en las lineas****';
END IF;

IF object_type = '17' and transaction_type in ('A','U')and 
(Select Distinct 'True'  FROM RDR1 T1 WHERE cast (T1."DocEntry" as nvarchar) = list_of_cols_val_tab_del
Group by T1."ItemCode" Having count (T1."LineNum") > 1) = 'True'
then
error='101';
		 error_message = ' ****No puede crear documento con codigos de articulos Repetido en las lineas ****';
END IF;


---PRUEBA DE BLOQUEO COMPROMETIDO
/*
if object_type = '17' and  transaction_type in ('A', 'U')
   then 
      if  (SELECT  Count (*) 
FROM ORDR T0
INNER JOIN RDR1 T1 ON T0."DocEntry" = T1."DocEntry"
INNER JOIN OITW T2 ON T1."ItemCode" = T2."ItemCode" and T1."WhsCode" = T2."WhsCode" 
WHERE  T1."Quantity" > ((T2."OnHand"-T2."IsCommited")+ T1."Quantity")  AND  T0."DocEntry" =   CAST(list_of_cols_val_tab_del AS NVARCHAR(15))  
) >= 1
      then
      error = 1013;
      error_message := N'** No puedes crear este documento ya que existe un articulo sin existencias disponibles por comprometido **';
   end if;
end if;

if object_type = '1250000001' and  transaction_type in ('A', 'U')
   then 
      if  (SELECT  Count (*)
FROM OWTQ T0
INNER JOIN WTQ1 T1 ON T0."DocEntry" = T1."DocEntry"
INNER JOIN OITW T2 ON T1."ItemCode" = T2."ItemCode"  and T1."FromWhsCod" = T2."WhsCode"
WHERE T1."Quantity" > ((T2."OnHand"-T2."IsCommited")+ T1."Quantity")  AND T0."DocEntry" = CAST(list_of_cols_val_tab_del AS NVARCHAR(15))  
) >= 1
      then
      error = 1013;
      error_message := N'** No puedes crear este documento ya que existe un articulo sin existencias disponibles por comprometido **';
   end if;
end if;
*/
-----------

--------------------------------------------------------------------------------------------------------------------------------

-- Select the return values
select :error, :error_message FROM dummy;

end;
