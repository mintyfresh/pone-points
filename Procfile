web: bin/rails server -p ${PORT:-5000} -e $RAILS_ENV
worker: worker: env QUEUE=* TERM_CHILD=1 INTERVAL=0.1 RESQUE_PRE_SHUTDOWN_TIMEOUT=20 RESQUE_TERM_TIMEOUT=8 bin/rails resque:work
