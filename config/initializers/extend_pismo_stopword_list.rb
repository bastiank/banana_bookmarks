#stopwords_solr_en_de = Rails.root.join("solr","conf","stopwords.txt").readlines.reject{|x| x.strip.start_with?("#") || x.strip.blank?}.map(&:strip)
stopwords_solr_en_de = Rails.root.join("config","stopwords","solr.txt").readlines.reject{|x| x.strip.start_with?("#") || x.strip.blank?}.map(&:strip)
stopwords_pismo_en = Rails.root.join("config","stopwords","pismo.txt").readlines.reject{|x| x.strip.start_with?("#") || x.strip.blank?}.map(&:strip)

Pismo.class_eval do
  @stopwords ||= (stopwords_solr_en_de + stopwords_pismo_en)
end
