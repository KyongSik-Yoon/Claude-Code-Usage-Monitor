# justfile for Claude Usage Monitor
# Install just: https://github.com/casey/just

# 기본 레시피
default:
    @just --list

# uv 설치 확인
check-uv:
    @echo "🔍 uv 설치 확인 중..."
    @uv --version || (echo "❌ uv가 설치되지 않았습니다. curl -LsSf https://astral.sh/uv/install.sh | sh" && exit 1)

# 의존성 설치
install: check-uv
    @echo "📦 의존성 설치 중..."
    uv pip install pytz --link-mode=copy
    npm install -g ccusage

# 개발 환경 설정
dev-setup: check-uv
    @echo "🔧 개발 환경 설정 중..."
    uv venv
    uv pip install -e . --link-mode=copy
    uv pip install pytz
    npm install -g ccusage

# 빌드
build: check-uv clean
    @echo "🏗️  패키지 빌드 중..."
    uv build

# 로컬 설치
install-local: build
    @echo "📥 로컬 설치 중..."
    uv pip install dist/*.whl --force-reinstall --link-mode=copy

# 테스트
test: install-local
    @echo "🧪 설치 테스트 중..."
    claude-usage-monitor --help

# 정리
clean:
    @echo "🧹 빌드 아티팩트 정리 중..."
    rm -rf dist/ build/ *.egg-info/

# 전체 빌드 프로세스
full-build: clean build install-local test
    @echo "🎉 빌드 완료!"

# PyPI 배포 (테스트)
publish-test: build
    @echo "📤 TestPyPI에 업로드 중..."
    uv pip install twine
    twine upload --repository testpypi dist/*

# PyPI 배포 (실제)
publish: build
    @echo "📤 PyPI에 업로드 중..."
    uv pip install twine
    twine upload dist/*

# 실행 (개발 모드)
run *ARGS: dev-setup
    @echo "🚀 개발 모드로 실행 중..."
    python ccusage_monitor.py {{ARGS}}

# 가상환경 활성화 도움말
venv-help:
    @echo "💡 가상환경 활성화 방법:"
    @echo "   source .venv/bin/activate    # Linux/Mac"
    @echo "   .venv\\Scripts\\activate       # Windows"