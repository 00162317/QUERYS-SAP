SELECT K."CardCode", K."CardName", T1."SlpName"
FROM OCRD K
INNER JOIN OSLP T1 ON K."SlpCode" = T1."SlpCode"
WHERE NOT EXISTS (
  SELECT 1 FROM OINV I WHERE K."CardCode" = I."CardCode"
) AND K."CardType" = 'C'