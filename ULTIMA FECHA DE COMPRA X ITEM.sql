SELECT T0."ItemCode", MAX(T0."DocDate") AS "UltimaFechaCompra"
FROM POR1 T0
GROUP BY T0."ItemCode"