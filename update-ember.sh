mkdir tmp
cd tmp
git clone git://github.com/emberjs/ember.js.git ember
cd ember
bundle install
bundle exec rake dist
cd ../..
rm vendor/scripts/ember-latest.js
cp tmp/ember/dist/ember.js vendor/scripts/ember-latest.js
rm -rf tmp/ember

cd tmp
git clone git://github.com/emberjs/data.git data
cd data
bundle install
bundle exec rake dist
cd ../..
rm vendor/scripts/ember-data-latest.js
cp tmp/data/dist/ember-data.js vendor/scripts/ember-data-latest.js
rm -rf tmp/data

cd tmp
git clone https://github.com/wycats/handlebars.js.git handlebars
cd handlebars
bundle install
bundle exec rake dist
cd ../..
rm vendor/scripts/handlebars-latest.js
cp tmp/handlebars/dist/handlebars.js vendor/scripts/handlebars-latest.js
rm -rf tmp/handlebars

cd tmp
git clone https://github.com/carhartl/jquery-cookie.git
cd ..
rm vendor/scripts/jquery.cookie-latest.js
cp tmp/jquery-cookie/jquery.cookie.js vendor/scripts/jquery.cookie-latest.js
rm -rf tmp/jquery-cookie

rmdir tmp
