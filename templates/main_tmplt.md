# Bevezető
Ezen oldalon szabadon elérhető COVID-19 esetszám-adatokat és népességszámokat felhasználva számolom ki a napi aktuális mérőszámokat, amelyek alapján [Ukrajna Egészségügyi Minisztériuma](https://moz.gov.ua/) minden pénteken az országok besorolását végzi. A táblázatban szereplő értékek minimális mértékben eltérhetnek a hivatalosan közöltektől (a Minisztérium valószínűleg más forrást használ a lakosságszám meghatározásához). Az előrejelzés alapjául az elmúlt *n* nap mozgó átlaga szolgál. Az értékek csupán tájékoztató jellegűek!

# Az osztályozás alapjául szolgáló képlet
`((elmúlt 14 nap új esetei összesen)/(ország lakossága))*100000`

# A legfrissebb napi összefoglalók
REPORTS

# Főbb változások
* 2020-12-19: az eddigi lineáris regresszió-alapú módszer helyett a következő péntekre szóló becslések mozgó átlagok alapján kerülnek kiszámításra.

# További linkek
* [A legfrissebb (2020. december 18.) hivatalos mérőszámok és ország-besorolások az Egészségügyi Minisztérium weboldaláról] (https://moz.gov.ua/uploads/5/27746-181220.png)

# Források
* napi új esetszámok a WHO oldaláról: https://covid19.who.int/WHO-COVID-19-global-data.csv
* 2019-es lakosságszám adatok a Világbank oldaláról: https://databank.worldbank.org/reports.aspx?source=2&series=SP.POP.TOTL&country=#
