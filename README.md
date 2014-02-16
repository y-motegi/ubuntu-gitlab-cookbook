I try to put ubuntu in vagrant this cookbook. 

-   config.vm.box_url = http://files.vagrantup.com/precise64.box

sit-cookbook/gitlab/recipes/default.rb
-   Part of the 189-197 line is not running correctly, it is currently under investigation. 

Because it does not create a branch, running twice, there is a part that you are trying to clone to double, it will not work correctly.
