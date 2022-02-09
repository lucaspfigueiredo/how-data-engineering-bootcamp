SELECT t1."date",
       t1."rank",
       t1.song,
       t1.artist,
       t1."last-week",
       t1."peak-rank",
       t1."weeks-on-board"
FROM   public."billboard" AS t1
LIMIT  100;  

SELECT t1.artist,
       t1.song
FROM   PUBLIC."billboard" AS t1
ORDER  BY t1.artist,
          t1.song;  

SELECT t1.artist,
       Count(*) AS qtd_artist
FROM   PUBLIC."billboard" AS t1
GROUP  BY t1.artist
ORDER  BY t1.artist;  

SELECT t1.song,
       Count(*) AS qtd_song
FROM   PUBLIC."billboard" AS t1
GROUP  BY t1.song
ORDER  BY t1.song;  

SELECT t1.artist,
       t2.qtd_artist,
       t1.song,
       t3.qtd_song
FROM   PUBLIC."billboard" AS t1
       LEFT JOIN (SELECT t1.artist,
                         Count(*) AS qtd_artist
                  FROM   PUBLIC."billboard" AS t1
                  GROUP  BY t1.artist
                  ORDER  BY t1.artist) AS t2
              ON ( t1.artist = t2.artist )
       LEFT JOIN (SELECT t1.song,
                         Count(*) AS qtd_song
                  FROM   PUBLIC."billboard" AS t1
                  GROUP  BY t1.song
                  ORDER  BY t1.song) AS t3
              ON ( t1.song = t3.song );  


WITH cte_artist
     AS (SELECT t1.artist,
                Count(*) AS qtd_artist
         FROM   PUBLIC."billboard" AS t1
         GROUP  BY t1.artist
         ORDER  BY t1.artist),
     cte_song
     AS (SELECT t1.song,
                Count(*) AS qtd_song
         FROM   PUBLIC."billboard" AS t1
         GROUP  BY t1.song
         ORDER  BY t1.song)
SELECT t1.artist,
       t2.qtd_artist,
       t1.song,
       t3.qtd_song
FROM   PUBLIC."billboard" AS t1
       LEFT JOIN cte_artist AS t2
              ON ( t1.artist = t2.artist )
       LEFT JOIN cte_song AS t3
              ON ( t1.song = t3.song );  


WITH cte_billboard
     AS (SELECT DISTINCT t1.artist,
                         t1.song
         FROM   public."billboard" AS t1
         ORDER  BY t1.artist,
                   t1.song)
SELECT *,
       Row_number()
         over(
           ORDER BY artist, song)  AS "row_number",
       Row_number()
         over(
           PARTITION BY artist
           ORDER BY artist, song)  AS "row_number_by_artist",
       Rank()
         over(
           PARTITION BY artist
           ORDER BY artist, song)  AS "rank_artist",
       Lag(song, 1)
         over(
           ORDER BY artist, song)  AS "lag_song",
       Lead(song, 1)
         over(
           ORDER BY artist, song)  AS "lead_song",
       First_value(song)
         over(
           PARTITION BY artist
           ORDER BY artist, song)  AS "first_song",
       Last_value(song)
         over(
           PARTITION BY artist
           ORDER BY artist, song RANGE BETWEEN unbounded preceding AND unbounded
         following)                AS "last_song",
       Nth_value (song, 2)
         over(
           PARTITION BY artist
           ORDER BY artist, song ) AS "nth_song"
FROM   cte_billboard; 


WITH T(StyleID, ID, Nome)
AS (SELECT 1,1, 'Rhuan' UNION ALL
SELECT 1,1, 'Andre' UNION ALL
SELECT 1,2, 'Ana' UNION ALL
SELECT 1,2, 'Maria' UNION ALL
SELECT 1,3, 'Letícia' UNION ALL
SELECT 1,3, 'Lari' UNION ALL
SELECT 1,4, 'Edson' UNION ALL
SELECT 1,4, 'Marcos' UNION ALL
SELECT 1,5, 'Rhuan' UNION ALL
SELECT 1,5, 'Lari' UNION ALL
SELECT 1,6, 'Daisy' UNION ALL
SELECT 1,6, 'João'
)
SELECT *,
ROW_NUMBER() OVER(PARTITION BY StyleID ORDER BY ID) AS "ROW_NUMBER",
RANK() OVER(PARTITION BY StyleID ORDER BY ID) AS "RANK",
DENSE_RANK() OVER(PARTITION BY StyleID ORDER BY ID) AS "DENSE_RANK",
PERCENT_RANK() OVER(PARTITION BY StyleID ORDER BY ID) AS "PERCENT_RANK",
CUME_DIST() OVER(PARTITION BY StyleID ORDER BY ID) AS "CUME_DIST",
CUME_DIST() OVER(PARTITION BY StyleID ORDER BY ID DESC) AS "CUME_DIST_DESC",
FIRST_VALUE(Nome) OVER(PARTITION by StyleID ORDER BY ID) AS "FIRST_VALUE",
LAST_VALUE(Nome) OVER(PARTITION by StyleID ORDER BY ID) AS "LAST_VALUE",
NTH_VALUE(Nome,5) OVER(PARTITION by StyleID ORDER BY ID) AS "NTH_VALUE",
NTILE (5) OVER (ORDER BY StyleID) as "NTILE_5",
LAG(Nome, 1) over(order by ID) as "LAG_NOME",
LEAD(Nome, 1) over(order by ID) as "LEAD_NOME"
FROM T;