"""Simplified forms of the table's names (the edition's body is in simplified Chinese); used by checks and the drafting."""
T = ('狀變動繫辭觀讀體餘諸網資絶絕結併與輸積來損竭圍開恆復歸藏剝廣狹賅長闔閉護機幾勢類並識數驗徵試聞見習過終參斷達無約貫當應擾擇緣劫環還報兆窮頻續閒繼蟄實聚毀稱讓舊惡顧親盡別權喪從設證說決錯後獨剛亡傳爭揜衆節濟備寬猛時隨執擬內舉測闕認愈致漸該徧異異萬氣於爲後擾曉義靜則轉處鬥歲勸禮學問聽')
S = ('状变动系辞观读体余诸网资绝绝结并与输积来损竭围开恒复归藏剥广狭赅长阖闭护机几势类并识数验征试闻见习过终参断达无约贯当应扰择缘劫环还报兆穷频续间继蛰实聚毁称让旧恶顾亲尽别权丧从设证说决错后独刚亡传争掩众节济备宽猛时随执拟内举测阙认愈致渐该遍异异万气于为后扰晓义静则转处斗岁劝礼学问听')
assert len(T) == len(S), (len(T), len(S))
MAP = dict(zip(T, S))
KEEP = {'闢': '闢'}  # 辟 would collide with 辟（譬）; the edition keeps 闢
def simp(name):
    return ''.join(KEEP.get(c, MAP.get(c, c)) for c in name)
if __name__ == '__main__':
    import csv, os
    rows = list(csv.DictReader(open(os.path.join(os.path.dirname(__file__), 'names-decisions.tsv'), encoding='utf-8'), delimiter='\t'))
    seen = {}
    for r in rows: seen.setdefault(simp(r['名']), []).append(r['名'])
    print('collisions:', {k: v for k, v in seen.items() if len(v) > 1})
    print(' '.join(simp(r['名']) for r in rows))
