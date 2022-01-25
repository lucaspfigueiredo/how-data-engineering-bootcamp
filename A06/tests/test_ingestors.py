import datetime

from unittest.mock import patch, mock_open

import pytest

from mercado_bitcoin.ingestors import DataIngestor
from mercado_bitcoin.writers import DataWriter

@pytest.fixture
@patch("ingestors.DataIngestor.__abstractmethods__", set())
def data_ingestor_fixtures():
    return DataIngestor(
            writer=DataWriter,
            coins=["HOW", "lucas", "TEST"],
            default_start_date=datetime.datetime(2022, 1, 2)
        )

@patch("ingestors.DataIngestor.__abstractmethods__", set())
class TestIngestor():
    def test_checkpoint_filename(self, data_ingestor_fixtures):
        actual = data_ingestor_fixtures._checkpoint_filename
        expected = "DataIngestor.checkpoint"
        assert actual == expected


    def test_load_checkpoint_no_checkpoint(self, data_ingestor_fixtures):
        actual = data_ingestor_fixtures._load_checkpoint()
        expected = datetime.datetime(2022, 1, 2)
        assert actual == expected

    @patch("builtins.open", new_callable=mock_open, read_data="2022-1-2")
    def test_load_checkpoint_existing_checkpoint(self, mock, data_ingestor_fixtures):
        actual = data_ingestor_fixtures._load_checkpoint()
        expected = datetime.date(2022, 1, 2)
        assert actual == expected

    @patch("ingestors.DataIngestor._write_checkpoint", return_value=None)
    def test_update_checkpoint_checkpoint_updated(self, mock, data_ingestor_fixtures):
        data_ingestor_fixtures._update_checkpoint(value=datetime.date(2022, 1, 2))
        actual = data_ingestor_fixtures._checkpoint
        expected = datetime.date(2022, 1, 2)
        assert actual == expected

    @patch("ingestors.DataIngestor._write_checkpoint", return_value=None)
    def test_update_checkpoint_checkpoint_written(self, mock, data_ingestor_fixtures):
        data_ingestor_fixtures._update_checkpoint(value=datetime.date(2022, 1, 2))
        mock.assert_called_once()

    @patch("builtins.open", new_callable=mock_open, read_data="2022-1-2")
    @patch("ingestors.DataIngestor._checkpoint_filename", return_value="foobar.checkpoint")
    def test_write_checkpoint(self, mock_checkpoint_filename, mock_open_file, data_ingestor_fixtures):
        data_ingestor_fixtures._write_checkpoint()        
        mock_open_file.assert_called_with(mock_checkpoint_filename, "w")
