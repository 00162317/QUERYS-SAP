SELECT  
T0."DocDate",
T0."GrosProfit"
,T0."SlpName"
,T0."CardCode"
,T0."CARDNAME"
,T0."DocNum"
,ROUND(t0."DIAS",0) AS "DIAS"
,T0."DocEntry"
,T0."Memo"
,T0."MONTO_BRUTO"
,T3."Pagado"
,T0."U_Comision"
,T1."FECHA_PAGO", 
T2."VENTA",
T0."%_Ganancia_Linea"

FROM  "10028_COPPER_ES"."COMISIONES" T0 

LEFT JOIN "10028_COPPER_ES"."PAGOSSV"  T1 ON T0."DocEntry" = T1."DocEntry"

LEFT JOIN (select "VENDEDOR", SUM("TOTAL") VENTA 
            from "10028_COPPER_ES"."VENTAS" 
            WHERE "FECHA" >=  '20230201' AND "FECHA"  <= '20230228' 
            GROUP BY  "VENDEDOR") T2 ON T2."VENDEDOR" = T0."SlpName"

LEFT JOIN (SELECT  T0."DocNum" , (T0."DocTotal" - T0."PaidToDate")  as "Pagado"
            FROM "10028_COPPER_ES"."OINV" T0 ) T3 ON T0."DocNum" = T3."DocNum"