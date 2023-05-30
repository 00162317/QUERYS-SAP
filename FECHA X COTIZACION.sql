SELECT T0."DocNum" CORRELATIVO,T0."DocDate" FECHA, T0."DocStatus", T0."U_Estado", T1."SlpName" VENDEDOR, T1."Memo" "Sucursal", T0."CardCode" CODIGO_CLIENTE, 
T0."CardName", T0."DocTotal",    (T0."DocTotal"-  T0."VatSum") "Total Bruto" ,T0."GrosProfit" "Ganancia",
case when (T0."DocTotal"-  T0."VatSum") = 0 then 0 else 
((T0."GrosProfit"*100) / (T0."DocTotal"-  T0."VatSum")) end as "%GM",

 T0."DocDueDate" FECHA_VENC
 
 FROM OQUT T0  INNER JOIN OSLP T1 ON T0."SlpCode" = T1."SlpCode"

WHERE T0."DocDate" >= [%0] AND T0."DocDate" <= [%1]

ORDER BY T0."DocTotal" DESC
