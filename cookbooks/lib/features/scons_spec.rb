describe 'scons installation' do
  describe command('scons -v') do
    its(:stdout) { should match(/v\d/) }
    its(:exit_status) { should eq 0 }
  end

  describe 'scons commands' do
    before :each do
      sh("rm -f #{Support.libdir}/features/files/helloworld.o " \
         "#{Support.libdir}/features/files/helloworld")
    end

    describe command("scons -C #{Support.libdir}/features/files") do
      its(:stdout) do
        should include(
          'scons: Reading SConscript files ...',
          'scons: done reading SConscript files.',
          'scons: Building targets ...',
          'gcc -o helloworld.o -c helloworld.c',
          'gcc -o helloworld helloworld.o',
          'scons: done building targets.'
        )
      end
    end

    describe command("cd #{Support.libdir}/features/files; scons --tree=all") do
      its(:stdout) do
        should include(
          '+-.',
          '  +-SConstruct',
          '  +-helloworld',
          '  | +-helloworld.o',
          '  | | +-helloworld.c',
          '  | | +-/usr/bin/gcc',
          '  | +-/usr/bin/gcc',
          '  +-helloworld.c',
          '  +-helloworld.o',
          '    +-helloworld.c',
          '    +-/usr/bin/gcc',
          'scons: done building targets.'
        )
      end
    end
  end
end
