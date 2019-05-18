/* Koostada protseduur, mille parameetriks on turniiri number ja tulemuseks
kahe rea ja kahe veeruga tabel: eesnimi ja perenimi isikutelt, kes olid
esimene ja viimane antud turniiril. */

CREATE PROCEDURE sp_esimene_ja_viimane(a_turniir integer)
RESULT (
    eesnimi VARCHAR(50),
    perenimi VARCHAR(50)
)
BEGIN
    SELECT eesnimi, perenimi FROM (
        (SELECT TOP 1 eesnimi, perenimi, SUM(punkt) as P
            FROM v_punktid JOIN Isikud ON V_punktid.mangija = Isikud.id
            WHERE turniir = a_turniir
            GROUP BY Eesnimi, Perenimi
            ORDER BY P DESC)
        UNION ALL
        (SELECT TOP 1 eesnimi, perenimi, SUM(punkt) as P
            FROM v_punktid JOIN Isikud ON V_punktid.mangija = Isikud.id
            WHERE turniir = a_turniir
            GROUP BY Eesnimi, Perenimi
            ORDER BY P ASC)
    ) AS K;
END

/* Näidata infot (ühe veeruna) kujul "Perenimi, Eesnimi [klubinimi]", kes said
rohkem kui 3 punkti (võit annab ühe ja viik pool punkti) Punkte arvutada üle
kõigi partiide. */

SELECT isik_nimi || ' [' || klubi_nimi || ']' FROM (
    SELECT isik_nimi, klubi_nimi, SUM(punkte) as P
        FROM v_edetabelid JOIN v_mangijad ON v_mangijad.isik_nimi = v_edetabelid.mangija
        GROUP BY isik_nimi, klubi_nimi
) AS K WHERE P > 3;
