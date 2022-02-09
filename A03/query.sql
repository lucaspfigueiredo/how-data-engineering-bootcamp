CREATE TABLE public."Billboard1" (
"date" date NULL,
"rank" int4 NULL,
song varchar(300) NULL,
artist varchar(300) NULL,
"last-week" float8 NULL,
"peak-rank" int4 NULL,
"weeks-on-board" int4 NULL
);

select
TBB."date",
TBB."rank",
TBB.song,
TBB.artist,
TBB."last-week",
TBB."peak-rank",
TBB."weeks-on-board"
from
"Billboard" as TBB
limit 10;

select max(TBB."date") as max_date from "Billboard" as TBB limit 10;

select
TBB."date",
TBB."rank",
TBB.song,
TBB.artist,
TBB."last-week",
TBB."peak-rank",
TBB."weeks-on-board"
from
"Billboard" as TBB
where TBB."date" = '2021-03-13';

select
TBB."date",
TBB."rank",
TBB.song,
TBB.artist,
TBB."last-week",
TBB."peak-rank",
TBB."weeks-on-board"
from
"Billboard" as TBB
where TBB."date" = '2021-03-13' and TBB."rank" <= 10;