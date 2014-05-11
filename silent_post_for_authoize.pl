#!/usr/bin/perl

#handle authorize.net API postback in perl
#deals with the following
#authorize only 
#checking the hash to make sure it matches avoiding fraud
#card accepted
#reoccuring billing
#canceling the order
#any question email me@hardenedwp.com

use CGI; $query=new CGI;
use Digest::MD5 qw/md5_hex/;


$trandate = `date +"%m/%d/%y"`; chop($trandate); 
$trantime = `date +"%I:%M %p"`; chop($trantime);
$x_type = $query->param('x_type');
$x_response_code = $query->param('x_response_code');
$x_subscription_paynum  = $query->param('x_subscription_paynum');
$x_trans_id =$query->param('x_trans_id'); 
$x_amount = $query->param('x_amount');


my $post_data = $query->query_string . ';tran_date=' . $trandate . ';tran_time=' . $trantime;

open (QUICKLOG,">> silent-post.txt"); # If you can't open just return.  
print QUICKLOG "$post_data\n";
close QUICKLOG; 

if ($x_type eq 'auth_only') {exit;} #dont need to try in my case
#md5hash
#http://developer.authorize.net/guides/SIM/wwhelp/wwhimpl/js/html/wwhelp.htm#href=SIM_Trans_response.html#1062745
$authorize_hash_value ="******************"; #plugin your own
$api_login = "***************"; #plugin your own
$hash_value = uc(md5_hex($authorize_hash_value . $x_trans_id . $x_amount)); #xauth and xcapture

#make sure you get no craziness
if ($hash_value ne  $x_MD5_Hash){ exit;}

if ($x_response_code eq 1) { #card accepted

 #card was accepted do something
 AcceptedOrder($x_subscription_id);

if ($x_subscription_paynum > 1){ #was a reoccuring
 
  #handle your reoccuring
  ReoccuringdOrder($x_subscription_id);
}

}

if ($x_response_code eq 2) { #card declined turn off subscription
  CancelOrder($x_subscription_id);
}

print "Content-type: text/html\n\n";
print 'SCRIPT COMPLETE';
exit;


#do what you need when a card is canceled
sub CancelOrder{ local($ID)=@_; my @S=();

return;
} 


#card accepted 
sub AcceptedOrder{ local($ID)=@_; my @S=();

return;
} 

#reoccuring 
sub ReoccuringdOrder{ local($ID)=@_; my @S=();

return;
} 