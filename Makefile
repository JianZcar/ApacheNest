install:
	@echo "Installing ApacheNest..."
	@sudo cp -r ./bin/apachenest /usr/local/bin/apachenest
	@sudo chmod +x /usr/local/bin/apachenest
	@echo "ApacheNest installed successfully."

uninstall:
	@echo "Uninstalling ApacheNest..."
	@sudo rm -f /usr/local/bin/apachenest
	@echo "ApacheNest uninstalled successfully."