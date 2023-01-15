describe Chitter do
  include Sinatra::TestHelpers

  let(:app) { Chitter.new }

  def check200
    expect(@response.status).to eq 200
  end

  def check_order_within_body(*regexs)
    regexs[0...(-1)].each.with_index do |regex, index|
      expect(@response.body =~ regex).to be < (@response.body =~ regexs[index + 1])
    end
  end

  context "GET /" do
    it "Returns 200 ok status and HTML homepage with all Cheeps in reverse" \
    "chronological order" do
      @response = get("/")
      check200
      expect(@response.body).to include("Posted at:").exactly(30).times
      expect(@response.body).to include(
        "<h1>Chitter</h1>",
        "productize robust relationships",
        "embrace open-source architectures",
        "leverage magnetic niches"
      )
      check_order_within_body(
        /leverage magnetic niches/,
        /embrace open-source architectures/,
        /productize robust relationships/
      )
    end

    it "Each Cheep is accompanied by its author's username" do
      @response = get("/")
      expect(@response.body).to include(
        "marianne.grant",
        "regine.tremblay",
        "dominica",
      )
      check_order_within_body(
        /dominica/,
        /regine.tremblay/,
        /marianne.grant/,
      )
    end

  end

  context "POST /user" do
    it "Adds a new user to database" do
      @response = post("/user",
        name: "Finn McCool",
        username: "mccool99",
        email: "finnmccool99@example.com",
        password: "very_secure123"
      )
      check200
      expect(User.last.name).to eq "Finn McCool"
    end
  end
end