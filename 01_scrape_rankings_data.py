import scrapy
import json
from datetime import datetime

class QuotesSpider(scrapy.Spider):
    user_agent = 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36'

class MenrankingSpider(scrapy.Spider):
    name = 'menranking'
    allowed_domains = ['fifa.com']
    start_urls = ['https://www.fifa.com/fifa-world-ranking/men']#?dateId=id13974

    def parse(self, response):
        script_content = response.xpath('//script[contains(., "dates")]/text()').extract_first()
        date_list = json.loads(script_content)
        #json.dump(date_list,open("myfile.json", "w") )#

        date_list = date_list['props']['pageProps']['pageData']['ranking']['dates']
        print(date_list)
        for item_id in date_list:
            print("output:")
            #print(item_id['dates'][0]['id'])
            #print("")
            for sub_item_id in item_id['dates']:
                url = f"https://www.fifa.com/api/ranking-overview?locale=en&dateId={sub_item_id['id']}"
                date_text = sub_item_id['iso']
                date = datetime.strptime(date_text, '%Y-%m-%dT%H:%M:%S.%fZ').strftime('%Y-%m-%d')
                print(f"{date}\n")
                yield scrapy.Request(url=url, callback=self.parse_ranking_data, meta={'date':date})

            

    def parse_ranking_data(self, response):
        data = json.loads(response.body) 
        base_url = 'https://www.fifa.com'
        for ranking_data in data['rankings']:
            yield {
                'rank_date': response.meta['date'],
                'country_full': ranking_data['rankingItem']['name'],
                'rank': ranking_data['rankingItem']['rank'],
                'previous_rank' : ranking_data['rankingItem']['previousRank'],
                'total_points': ranking_data['rankingItem']['totalPoints'],
                'previous_points': ranking_data['previousPoints'],
                'flagUrl': ranking_data['rankingItem']['flag']['src'],
                'countryUrl': base_url + ranking_data['rankingItem']['countryURL'],
                'conf': ranking_data['tag']['text'] 
            }


#scrapy runspider menrankings_v2.py -o data.csv