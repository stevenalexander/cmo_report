echo "running tests"
rspec -f d -c spec/
if [[ $? != 0 ]] ; then
	exit $?
fi
jasmine-headless-webkit -c -j spec/javascripts/support/jasmine.yml spec/jasmine/
exit $?