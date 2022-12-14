WITH RECURSIVE MENU_TREE (
	 MENU_ID
	,MENU_NM
	,MENU_PID
	,MENU_URL
	,MENU_ICON
  	,DISPLAY_NO
 	,DISPLAY_YN
	,USE_YN
	,MENU_STEP
	,FULL_PATH
	,MENU_SORT
-- 	,MENU_PATH
) AS (
	SELECT
		 A.MENU_ID
		,A.MENU_NM
		,A.MENU_PID
		,A.MENU_URL
		,A.MENU_ICON
 		,A.DISPLAY_NO
 		,A.DISPLAY_YN
		,A.USE_YN
		,1 AS MENU_STEP
		,CAST(A.MENU_NM AS BINARY) AS FULL_PATH
		,CAST(A.MENU_ID AS BINARY) AS MENU_SORT
--         ,CAST(FORMAT(A.DISPLAY_NO, '000') + '-' + A.MENU_ID AS BINARY) AS MENU_SORT
 --               ,A.MENU_NM AS MENU_PATH
	FROM MENUS A
	WHERE A.USE_YN = 'Y' AND A.DISPLAY_YN = 'Y' AND A.MENU_PID IN ('000000', NULL)
	UNION ALL
	SELECT
		 B.MENU_ID
		,B.MENU_NM
		,B.MENU_PID
		,B.MENU_URL
		,B.MENU_ICON
 		,B.DISPLAY_NO
 		,B.DISPLAY_YN
		,B.USE_YN
		,MENU_STEP + 1 AS MENU_STEP
		,CAST(CONCAT(FULL_PATH, '>', B.MENU_NM) AS BINARY) AS FULL_PATH
		,CAST(CONCAT(MENU_SORT, '|', B.MENU_ID) AS BINARY) AS MENU_SORT
-- 		,CAST(MENU_SORT + '|' + FORMAT(B.DISPLAY_NO, '000') + '-' + B.MENU_ID AS BINARY) AS MENU_SORT
--                ,T.FULL_PATH + '|' + B.MENU_NM AS MENU_PATH
	FROM MENUS B 
	    INNER JOIN MENU_TREE ON MENU_TREE.MENU_ID = B.MENU_PID
	WHERE B.USE_YN = 'Y' AND B.DISPLAY_YN = 'Y'
)
SELECT *
    ,CASE WHEN NOT EXISTS (SELECT T.MENU_ID  FROM MENUS T WHERE MENU_TREE.MENU_ID = T.MENU_PID) THEN 'Y' ELSE 'N' END AS IS_LEAF
    ,CASE WHEN 0 < (SELECT 1 FROM DUAL WHERE MENU_URL LIKE '/widgets/cards/basic.do') THEN 'Y' ELSE 'N' END AS IS_ACTIVE
FROM MENU_TREE 
	ORDER BY MENU_SORT, DISPLAY_NO 
