require 'minitest/autorun'
require 'ModelGenerator/Announcement'

class AnnouncementTest < Minitest::Test
  
  def setup 
    @annouce_gen = Announcement.new
  end

  def test_create_announcement
    content = @annouce_gen.createDeclare
    refute_nil content
  end

  def test_announcement_format
     content = @annouce_gen.createDeclare
     expect_content = /\/\/\s+\/\/  entity_name.h\s+\/\/  your_project_name\s+\/\/\s+\/\/  Created by .* on \d{2}-\d{2}-\d{2}.\s+\/\/  Copyright \(c\) \d{4}年 .*\. All rights reserved\./
     
     assert_match(expect_content, content)                     
  end 
    
end
