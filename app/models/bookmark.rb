class Bookmark < ActiveRecord::Base
  belongs_to :user
  attr_accessible :url

  validates_presence_of :user_id
  
  after_create :load_meta_data!

  acts_as_taggable

  searchable do
    text :url, :boost => 8
    text :title, :boost => 8
    text :tag_list, :boost => 5
    text :description, :boost => 3
    text :content_text, :boost => 2
    text :raw_text
  end

  def url= url                    
    url = "http://"+url unless url.start_with?("http://") || url.start_with?("https://")
    super url
  end

  def load_meta_data
    self.set_url_after_redirect
    self.set_page_dump
    self.set_title
    self.set_tags
    self.set_description
  end

  def load_meta_data!
    load_meta_data
    self.save
  end

  def set_url_after_redirect
    self.url = page.uri.to_s.force_encoding('UTF-8')
  end
  
  def set_url_after_redirect!
    self.set_url_after_redirect
    self.save!
  end

  def set_tags
    self.tag_list = (pismo_doc.keywords + pismo_doc.delicious_tags).map(&:first).map(&:downcase).uniq
  end
  
  def set_title
    self.title = pismo_doc.html_title || pismo_doc.title
    self.title = self.title.force_encoding('UTF-8')
  end

  def set_page_dump
     charset = page.meta_charset.first rescue "UTF-8"
    self.page_dump = page.content.force_encoding(charset).encode#('UTF-8', :invalid => :replace, :undef => :replace)
  end


  def set_description
    self.description = pismo_doc.description || pismo_doc.sentences || content_text.try("[]",0..160)
    self.description = self.description.force_encoding('UTF-8')
  end
  
  def raw_text
    pismo_doc.reader_doc.raw_content.gsub(/<\/?[^>]*>/, " ").gsub(/\s+/, ' ')
  end
  
  def content_text
    return pismo_doc.reader_doc.content(true) || self.raw_text 
  end

  #private
  def mechanize_agent
    @mechanize_agent ||= Mechanize.new { |agent|
        agent.user_agent_alias = 'Mac Safari'
    }
  end

  def page
    @page ||= mechanize_agent.get(self.url)
  end

  def pismo_doc
    @pismo_doc ||= Pismo::Document.new(self.page_dump)
  end
end
