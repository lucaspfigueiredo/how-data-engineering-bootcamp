 CREATE VIEW vw_song AS
            (
                   SELECT *
                   FROM   tb_first_song
            );INSERT INTO tb_first_song
            (
                        with cte_dedup AS
                        (
                                 SELECT   t1."date" ,
                                          t1."rank" ,
                                          t1.song ,
                                          t1.artist ,
                                          row_number() OVER(partition BY t1.artist, t1.song ORDER BY t1.artist,t1.song, t1."date") AS dedup_song ,
                                          row_number() OVER(partition BY t1.artist ORDER BY t1.artist, t1."date")                  AS dedup_artist
                                 FROM     PUBLIC."Billboard"                                                                       AS t1
                                 ORDER BY t1.artist ,
                                          t1."date" )SELECT t1."date" ,
                      t1."rank" ,
                      t1.artist ,
                      t1.song
               FROM   cte_dedup AS t1
               WHERE  t1.artist LIKE '%Elvis%'
               AND    t1.dedup_song = 1
            )SELECT *
     FROM   vw_song;CREATE OR replace VIEW vw_song AS
                            (
                                   SELECT *
                                   FROM   tb_first_song AS t1
                                   WHERE
                            ); 