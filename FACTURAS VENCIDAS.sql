SELECT T0."DocNum" as "Numero Documento", T0."DocDate", T0."CardCode", T0."CardName", T1."SlpName",
DAYS_BETWEEN(T0."DocDueDate", CURRENT_DATE) as "Dias Vencidos", SUM(T0."PaidToDate") as "Pagos Recibidos",
SUM(T0."DocTotal" - T0."PaidToDate") as "Saldo Pendiente"
FROM OINV T0
INNER JOIN OSLP T1 ON T1."SlpCode" = T0."SlpCode"
WHERE T0."CANCELED" = 'N' AND T0."DocStatus" = 'O'
GROUP BY 
T0."DocNum",T0."DocDate",T0."CardCode",T0."CardName",T1."SlpName",T0."DocDueDate"

