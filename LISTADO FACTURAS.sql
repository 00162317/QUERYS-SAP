SELECT DISTINCT
CASE WHEN T0."CANCELED" ='Y' THEN 'Anulada' ELSE 'Correcto' END Status
,
T0."DocEntry", T0."CardName",

CASE WHEN T0."DocStatus" = 'C' THEN 'CERRADA' 
WHEN T0."DocStatus"='O' THEN 'ABIERTA'
ELSE T0."DocStatus"
end "estado",
SUBSTRING(T1."SeriesName",0,3) Tipo,
CASE 
WHEN T0."Series" = 89 THEN T0."DocNum" -2000000
WHEN T0."Series" = 83 THEN T0."DocNum" -1000000
ELSE T0."DocNum"  END AS DocNum,

 T0."NumAtCard", T1."BeginStr" , 
CASE WHEN SUBSTRING(T1."SeriesName",5,2) = 'JP' THEN 'JUAN PABLO'  
        WHEN SUBSTRING(T1."SeriesName",5,2) = 'SM' THEN 'SAN MIGUEL'
ELSE 'MERLIOT' 
END  Tipo, 
T0."DocDate",
CASE WHEN T0."CANCELED" ='Y' THEN 0 ELSE T0."DocTotal" END DocTotal ,
CASE 
WHEN T0."CANCELED" ='Y' THEN 0 
WHEN SUBSTRING(T1."SeriesName",0,3) ='CCF' THEN (T0."DocTotal"- T0."VatSum"+ T0."WTSumSC")
ELSE ((T0."DocTotal" - T0."VatSum")+T0."WTApplied")  END Venta_Neta,
CASE WHEN T0."CANCELED" ='Y' THEN 0 ELSE T0."PaidToDate" END Pagado ,
CASE WHEN T0."CANCELED" ='Y' THEN 0 ELSE T0."VatSum" END Impuesto , 
CASE WHEN T0."CANCELED" ='Y' THEN 0 ELSE T0."WTSumSC" END Retencion , 
T2."SlpName",
T10."PymntGroup"  "Condicion",

'____' _____,
T3."DocNum" Num_Anulacion,
T3."Comments" ,
T3."CreateDate" Fecha_anulacion
FROM OINV T0  
INNER JOIN NNM1 T1 ON T0."Series" = T1."Series"
LEFT JOIN "OCTG" T10 ON T0."GroupNum" = T10."GroupNum" 
INNER JOIN OSLP T2 ON T0."SlpCode" = T2."SlpCode"
LEFT JOIN (SELECT  
                X0."DocNum",
                X0."Comments",
                X0."DocDate",
                X0."CreateDate",
                X1."BaseType", X1."BaseEntry"
                FROM "OINV" X0
                LEFT JOIN "INV1" X1 ON X0."DocEntry" = X1."DocEntry" 
                WHERE X0."CANCELED" = 'C') T3 ON T3."BaseEntry" = T0."DocEntry" 
 
WHERE
T0."DocDate"  >=[%0] AND  T0."DocDate" <=[%1]