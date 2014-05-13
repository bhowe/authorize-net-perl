#!/usr/bin/perl


#just call it like so  ProcessCreditCardAtAuthorizeNet: 
sub ProcessCreditCardAtAuthorizeNet{
  
  $authorize_api_login = "*********************************";
  $authorize_api_key =   "*********************************";
  $post_url = "https://secure.authorize.net/gateway/transact.dll";
  #look up all your credit card info either post or database and pass it in here
  #make sure to sanitize data
 
  &DoAuthorizeNet; 


}
 #========================================================== 
sub DoAuthorizeNet{ local($URL,$ua,$req,$res)=''; 

local ($cardnumber,$expiremonth,$expireyear,$amount,$ordernum,$description,$lastname,$firstname,$email,$address,$city,$state,$zip,$country)=@_;


my $post_values	= 
{
	# the API Login ID and Transaction Key must be replaced with valid values
	"x_login"			=> $authorize_api_login,
	"x_tran_key"		=> $authorize_api_key,

	"x_version"			=> "3.1",
	"x_delim_data"		=> "TRUE",
	"x_delim_char"		=> "|",
	"x_relay_response"	=> "FALSE",

	"x_type"			=> "AUTH_ONLY",
	"x_method"			=> "CC",
	"x_card_num"		=> $cardnumber,
	"x_exp_date"		=> $carddate ,

	"x_amount"			=> "$amount",
	"x_description"		=> $description,

	"x_first_name"		=> $firstname,
	"x_last_name"		=> $lastname,
	"x_address"			=> $address,
	"x_state"			=> $state,
	"x_zip"				=> $zip	
	
};



my $useragent	= LWP::UserAgent->new( protocols_allowed => ["https"] );

#form the XML

		use POSIX qw(strftime);

		my $date = strftime "%Y-%m-%d", localtime;
       

		$xml = "<?xml version='1.0' encoding='utf-8'?>
                  <ARBCreateSubscriptionRequest xmlns='AnetApi/xml/v1/schema/AnetApiSchema.xsd'>
                  <merchantAuthentication>
                          <name>$authorize_api_login</name>
                          <transactionKey>$authorize_api_key</transactionKey>
                      </merchantAuthentication>
                      <refId></refId>
                       <subscription>
                          <name>". $firstname ."</name>
                          <paymentSchedule>
                              <interval>
                                  <length>1</length>
                                  <unit>months</unit>
                              </interval>
                              <startDate>".$date."</startDate>
                              <totalOccurrences>120</totalOccurrences>
                              <trialOccurrences>0</trialOccurrences>
                          </paymentSchedule>
                          <amount>$amount</amount>
                          <trialAmount>0</trialAmount>
                          <payment>
                              <creditCard>
                                  <cardNumber>" . $cardnumber. "</cardNumber>
                                  <expirationDate>".$carddate."</expirationDate>
                              </creditCard>
                          </payment>
                          <order>
                           <invoiceNumber>$OrderNumber</invoiceNumber>
                          <description>$description</description>
                          </order>
                          <billTo>
                              <firstName>".  $firstname  . "</firstName>
                              <lastName>" .  $lastname  . "</lastName>
                              <address>" . $address. "</address>
                              <city>" . $city. "</city>
                              <state>" . $state. "</state>
                              <zip>" . $zip. "</zip>
                              <country>US</country>
                          </billTo>
                      </subscription>
       
                  </ARBCreateSubscriptionRequest>";
                  
                  
                 if ( $AuthorizeResponse eq '')
                 { 

					use HTTP::Request::Common;
					use LWP::UserAgent;
					$ua = LWP::UserAgent->new;
					my $request = POST $post_url, Content_Type => 'text/xml; charset=utf-8', Content => $xml;
					$res = $ua->request($request);	
					
					if ($res->is_success) {  
				     	&GetResponseData;  
					 	&HandleResponseData;  		     
					 } else { &HandleFailure; }
				 } 
				0;
}
 #=====================================================
sub GetResponseData{

		my $resp='';
		my $string=$res->as_string;
		my @response =split(/\n/,$string); my $url=$URL; $url=~s/\&/ \&/g; 
	    $AuthorizeResponse='';  # THIS MUST BE A GLOBAL!!!!
        $Authorize_subid='';  # THIS MUST BE A GLOBAL!!!!
	    
	    #i dont care about anything but the XML returned
		foreach $resp(@response){ 
		     if ($resp=~/ARBCreateSubscriptionResponse/){ $AuthorizeResponse.="$resp";} # put in for change to their server circa Jan 2011 
		      if ($resp=~/subscriptionId/){  $Authorize_subid.="$resp";} # put in for change to their server circa Jan 2011 
		  }
		  
	  $AN_response_reason_text;	  
}

sub HandleResponseData{


	if (($AuthorizeResponse=~"<resultCode>Error<\/resultCode>")){
		$AuthorizeResponse=~"<text>(.+?)<\/text>";
		$AN_response_reason_text="<p>$1</p>.";;  
	}


	if (($Authorize_subid=~"<resultCode>Ok<\/resultCode>")){
		$AuthorizeResponse=~"<subscriptionId>(.+?)<\/subscriptionId>";
		$Authorize_subid ="$1.";
	}
	 
}



 #=====================================================
sub HandleFailure{

	$AN_response_reason_text="<p>The accounting processor that we use for all credit card transactions is currently not available.<p>We are sorry but this is beyond our control.  Please try 		again in a few minutes.";

}

1; 
