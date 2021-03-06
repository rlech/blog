require 'test_helper.rb'

class PostOperationTest < MiniTest::Spec

  it "validate correct input" do
    op = Post::Create.(title: "Test", subtitle: "Subtitle", author: "Nick", body: "whatever")
    op.model.persisted?.must_equal true
    op.model.title.must_equal "Test"
    op.model.content.must_equal({"subtitle"=>"Subtitle", "author"=>"Nick", "body"=>"whatever"})
  end

  it "wrong input" do
    res, op = Post::Create.run(post: {})
    res.must_equal false
    op.errors.to_s.must_equal "{:title=>[\"is missing\"], :\"content.subtitle\"=>[\"is missing\"], :\"content.author\"=>[\"is missing\"], :\"content.body\"=>[\"is missing\"]}"
  end


  it "modify post" do
    op = Post::Create.(title: "Test", subtitle: "Subtitle", author: "Nick", body: "whatever")
    op.model.title.must_equal "Test"

    op = Post::Update.(id: op.model.id, title: "newTitle")
    op.model.persisted?.must_equal true
    op.model.title.must_equal "newTitle"
  end

  it "delete post" do
    op = Post::Create.(title: "Test", subtitle: "Subtitle", author: "Nick", body: "whatever")
    op.model.persisted?.must_equal true

    op = Post::Delete.(id: op.model.id)
    op.model.persisted?.must_equal false
  end

end 