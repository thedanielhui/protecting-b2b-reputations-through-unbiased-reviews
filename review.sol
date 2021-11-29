pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";

contract Review is KeeperCompatibleInterface {

    /* TODO: 
        [] chainlink keeper for drawing another review
        [] adaptor to pull reviews from yelp
    */

    /////////////////
    // YELP DATA (chainlink adaptor)
    // https://www.yelp.com/biz/nespresso-boutique-san-francisco-4
    struct YelpReviews {
        string title;
        string timestamp;
        string reviewer;
        string content;
    }
    YelpReviews[] yelpReviews;
    ///////////////
    //////////////

    /////////////
    // TOPIC
    // title
    string public topic_title;
    // funds
    uint256 public topic_fund_balance;
    uint256 public required_topic_fund_amount = 1 gwei;
    uint256 public required_filter_review_amount = 1 gwei;
    ////////////////////

    ////////////
    // FILTERED REVIEWS
    struct Review { 
        string title;
        uint256 filtered_timestamp;
        string timestamp;
        string reviewer;
        string content;
    }
    Review[] public reviews;
    //////////////

    uint reviewIndex = 0;
    uint256 _chainlinkFee = 0.1 * 10 ** 18; // 0.1 LINK

    constructor() {

        // dev: seed with yelp reviews.
        // todo: connect adaptor
        yelpReviews.push( YelpReviews(
            "Nespresso Boutique",
            "10/25/2021",
            "Mary L.",
            "Another positive experience with purchasing pods through the boutique for both the Original and Vertuo machines. I've been a Nespresso Original line customer for years and have purchased Vertuo pods for friends / family.  I am 'old school' and prefer to shop in store / in person whenever possible. I've been Paul's customer for years; he has always provided consistent, professional, helpful and friendly customer service. He makes recommendations on different coffees that he thinks I would enjoy based upon my taste preferences.  Thanks again, Paul!")
        );
        yelpReviews.push( YelpReviews(
            "Nespresso Boutique",
            "10/6/2020",
            "Ruchika M.",
            "Not the best cup of coffee I have had, but good. Nespresso always has a laudable, chic ambience. Definitely worth venturing to a boutique at least once and trying one of their crafted drinks.")
        );
        yelpReviews.push( YelpReviews(
            "Nespresso Boutique",
            "10/29/2021",
            "vtoni t.",
            "Very bad service! And the manager was very useless to talked to about my complain.")
        );
    }
    
    function setTopic( string memory title ) public payable {
        require( msg.value >= required_topic_fund_amount, "You did not add enough funds." );
        topic_title = title;
        topic_fund_balance = msg.value;
    }

    function filterReview() public {

        require( topic_fund_balance >= required_filter_review_amount, "You did not have enough funds.  Add more." );
        require( isTopicFound( topic_title ), "Your topic is not found.  Please create a topic."  );

        // get a review
        yelpReviews[reviewIndex];

        // do some oracle magic
        // code...

        // store review
        reviews.push(
            Review(
                yelpReviews[reviewIndex].title,
                block.timestamp, 
                yelpReviews[reviewIndex].timestamp,
                yelpReviews[reviewIndex].reviewer,
                yelpReviews[reviewIndex].content )
        );
        reviewIndex++;
    
    }

    function isTopicFound(string memory topic) internal returns (bool topicFound) {
        topicFound = false;
        for(uint i = 0; i < yelpReviews.length; i++) {
            if( keccak256(bytes(topic) ) == keccak256( bytes( yelpReviews[i].title ) ) ) {
                topicFound = true;
            }   
        }
    }

    ///////
    // KEEPERS
    function checkUpkeep(bytes calldata /*Checkdata*/) public view override returns (
        bool upkeepNeeded, bytes memory performData
    ) {
        // todo: Just for LINK.balance
        /*
        bool hasLink = LINK.balanceOf(address(this)) >= _chainlinkFee;
        upkeepNeeded = hasLink;
        */
        upkeepNeeded = true;
    }
    function performUpkeep(bytes calldata /*performData*/) external override {
        // s_state = State.Calculating;
        // require( LINK.balanceOf(address(this)) >= _chainlinkFee, "You need more link.");
        // requestRandomness(_keyHash, _chainlinkFee);
        filterReview();
    }
    ///////



}
