For example, using openssl:

     $ openssl dgst -sha224 /bin/ls
     SHA224(/bin/ls)= 118187da8364d490b4a7debbf483004e8f3e053ec954309de2c41a25

     It is also possible to use openssl to generate base64 output:

     $ openssl dgst -binary -sha224 /bin/ls | openssl base64
     EYGH2oNk1JC0p9679IMATo8+BT7JVDCd4sQaJQ==



