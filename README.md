[![Build Status](https://api.travis-ci.org/schweikert/postgrey.svg)](https://travis-ci.org/schweikert/postgrey)

# Postgrey - a Postfix policy server for greylisting

**`postgrey`** (written in Perl) is a [Postfix](http://www.postfix.org/) [policy server](http://www.postfix.org/SMTPD_POLICY_README.html) implementing
[greylisting](https://www.greylisting.org/) developed by [David Schweikert](http://david.schweikert.ch/)

- Homepage = http://postgrey.schweikert.ch/
- Project + Issues = https://github.com/schweikert/postgrey

## Requirements

- Perl >= 5.6.0
- Net::Server (Perl Module)
- IO::Multiplex (Perl Module)
- BerkeleyDB (Perl Module)
- Berkeley DB >= 4.1 (Library)
- Digest::SHA (Perl Module, only for --privacy option)
- NetAddr::IP


## Dev Documentation

To see POD documentation in postgrey. Execute:
```bash
perldoc postgrey
```

    


## Mailing-List and getting Help

There is a mailing-list for the discussion of postgrey, where you can
also ask for help in case of trouble. To subscribe, send a mail with
subject 'subscribe' to:

    postgrey-request@list.ee.ethz.ch 
  
There is also a mailing-list archive, where you might find answers:

   http://lists.ee.ethz.ch/wws/arc/postgrey
