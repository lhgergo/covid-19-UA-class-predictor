# Intro
Az itt található kód fut a https://lhgergo.shinyapps.io/covid-19-ua-class-predictor/ webhelyen.

Ezen oldalon Ukrajna Egészségügyi Minisztériumának számítási rendszere szerint mindenki kiszámolhatja az aktuális napi mérőszámokat, amelyek alapján minden pénteken az országok színek szerinti besorolása történik ("Országok aktuális besorolása" menüpont). A táblázatban szereplő értékek minimális mértékben eltérhetnek a hivatalosan közöltektől (a Minisztérium valószínűleg más forrást használ a lakosságszám meghatározásához).

A "Várható jövő heti besorolás" menüpont alatt egyelőre egy egyszerű lineáris modell alapján számolt jósolt számérték látható minden országra, nagyjából előrevetítve a következő pénteki helyzetet. Itt beállítható, hogy az elmúlt hány napot vegye figyelembe az algoritmus az előrejelzés megalkotásához.

# A besorolás alapját képező érték kiszámítás módja
`((elmúlt 14 nap új esetei összesen)/(ország lakossága))*100000`

# Hiányzó funkciók
* magyar és ukrán nyelvű országnevek
* 30%-nál nagyobb új esetszám-emelkedést mutató országokat egyelőre nem jelöltem vörösnek
* kifinomultabb módszer a következő napok esetszámainak becsléséhez

# Források
* napi új esetszámok a WHO oldaláról: https://covid19.who.int/WHO-COVID-19-global-data.csv
* 2019-es lakosságszám adatok a Világbank oldaláról: https://databank.worldbank.org/reports.aspx?source=2&series=SP.POP.TOTL&country=#
